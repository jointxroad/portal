---
layout: page_layout
sidebar:
  - href: "#general"
    text: General
  - href: "#java"
    text: Java
  - href: "#javascript"
    text: Javascript
---

Examples
============
## General

X-road uses SOAP version 1.1 messaging. When calling a service you need to make sure both SOAP header and body fields are properly filled, otherwise the call wont work. Note that some of the WSDL autogenerators/General SOAP client libraries don't seem to cope with the headers very well.

To get quickly started with development/testing you don't need to have full security server installation. Instead you can just run [X-Road Test Service](https://github.com/petkivim/x-road-test-service) locally and try your client code against it.

## JAVA
### wsimport
You need to manually insert SOAP headers into your client code. Below is an example how to use these headers and call getRandom method on testservice (using generated classes)

```java
TestService service = new TestService();
TestServicePortType port = service.getTestServicePort();
WSBindingProvider bp = (WSBindingProvider) port;

SOAPFactory factory = SOAPFactory.newInstance();

SOAPElement clientHeader = factory.createElement(new QName("http://x-road.eu/xsd/xroad.xsd", "client"));
clientHeader.addNamespaceDeclaration("id", "http://x-road.eu/xsd/identifiers");
clientHeader.addAttribute(new QName("", "objectType", "id"), "SUBSYSTEM");

SOAPElement sdsbInstance = clientHeader.addChildElement("xRoadInstance", "id");
sdsbInstance.addTextNode("FI_TEST");

SOAPElement memberClass = clientHeader.addChildElement("memberClass", "id");
memberClass.addTextNode("GOV");

SOAPElement memberCode = clientHeader.addChildElement("memberCode", "id");
memberCode.addTextNode("1234567-8");

SOAPElement subsystem = clientHeader.addChildElement("subsystemCode", "id");
subsystem.addTextNode("TestClient");

// Service soap header
SOAPElement serviceHeader = factory.createElement(new QName("http://x-road.eu/xsd/xroad.xsd", "service"));
serviceHeader.addNamespaceDeclaration("id", "http://x-road.eu/xsd/identifiers");

serviceHeader.addAttribute(new QName("", "objectType", "id"), "SERVICE");

sdsbInstance = serviceHeader.addChildElement("xRoadInstance", "id");
sdsbInstance.addTextNode("FI_TEST");

memberClass = serviceHeader.addChildElement("memberClass", "id");
memberClass.addTextNode("GOV");

memberCode = serviceHeader.addChildElement("memberCode", "id");
memberCode.addTextNode("1234567-8");

subsystem = serviceHeader.addChildElement("subsystemCode", "id");
subsystem.addTextNode("DemoService");

SOAPElement serviceCode = serviceHeader.addChildElement("serviceCode", "id");
serviceCode.addTextNode("getRandom");

SOAPElement serviceVersion = serviceHeader.addChildElement("serviceVersion", "id");
serviceVersion.addTextNode("v1");

bp.setOutboundHeaders(
  Headers.create(clientHeader),
  Headers.create(serviceHeader),
  Headers.create(new QName("http://x-road.eu/xsd/xroad.xsd", "id"), "ID11234"),
  Headers.create(new QName("http://x-road.eu/xsd/xroad.xsd", "userId"), "EE1234567890"),
  Headers.create(new QName("http://x-road.eu/xsd/xroad.xsd", "protocolVersion"), "4.0")
);
```


### wsdl2java
Apache CXF can generate SOAP header classes, when using [exsh](http://cxf.apache.org/docs/wsdl-to-java.html) parameter. Below is an example how to use these header classes and call getRandom method on testservice.

```java
XRoadClientIdentifierType clientHeaderValues = new XRoadClientIdentifierType();
clientHeaderValues.setObjectType(XRoadObjectType.fromValue("SUBSYSTEM"));
clientHeaderValues.setXRoadInstance("FI_TEST");
clientHeaderValues.setMemberClass("GOV");
clientHeaderValues.setMemberCode("1234567-8");
clientHeaderValues.setSubsystemCode("TestClient");
Holder<XRoadClientIdentifierType> clientHeader = new Holder<XRoadClientIdentifierType>(clientHeaderValues);

XRoadServiceIdentifierType serviceHeaderValues = new XRoadServiceIdentifierType();
serviceHeaderValues.setObjectType(XRoadObjectType.fromValue("SERVICE"));
serviceHeaderValues.setXRoadInstance("FI_TEST");
serviceHeaderValues.setMemberClass("GOV");
serviceHeaderValues.setMemberCode("9876543-1");
serviceHeaderValues.setSubsystemCode("DemoService");
serviceHeaderValues.setServiceCode("getRandom");
serviceHeaderValues.setServiceVersion("v1");
Holder<XRoadServiceIdentifierType> serviceHeader = new Holder<XRoadServiceIdentifierType>(serviceHeaderValues);

Holder<String> userIdHeader = new Holder<String>("122111");
Holder<String> idHeader = new Holder<String>("1");
Holder<String> protocolVersionHeader = new Holder<String>("4.0");

GetRandomResponse response = port.getRandom(getRandomMethod, clientHeader, serviceHeader, userIdHeader, idHeader, null, protocolVersionHeader);
```

### JAX-WS
In this example we call [X-Road Test Service](https://github.com/petkivim/x-road-test-service) using JAX-WS dynamic invocation.

```java
import javax.xml.namespace.QName;
import javax.xml.soap.*;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.ws.Dispatch;
import javax.xml.ws.Service;
import javax.xml.ws.soap.SOAPBinding;
...
...
QName SERVICE_NAME = new QName("http://test.x-road.fi/producer", "testService");
QName SERVICE_PORT = new QName("http://test.x-road.fi/producer", "testServicePort");

String url = "http://localhost:8080/example-adapter-0.0.4-SNAPSHOT/Endpoint?wsdl";

/** Create a service and add at least one port to it. **/
Service service = Service.create(SERVICE_NAME);
service.addPort(SERVICE_PORT, SOAPBinding.SOAP11HTTP_BINDING, url);

/** Create a Dispatch instance from a service.**/
Dispatch<SOAPMessage> dispatch = service.createDispatch(SERVICE_PORT, SOAPMessage.class, Service.Mode.MESSAGE);

/** Create SOAPMessage request. **/
// compose a request message
MessageFactory mf = MessageFactory.newInstance(SOAPConstants.SOAP_1_1_PROTOCOL);

// Create a message.  This example works with the SOAPPART.
SOAPMessage request = mf.createMessage();
SOAPPart part = request.getSOAPPart();

// Obtain the SOAPEnvelope and header and body elements.
SOAPEnvelope env = part.getEnvelope();
SOAPHeader header = env.getHeader();
SOAPBody body = env.getBody();

env.addNamespaceDeclaration("id", "http://x-road.eu/xsd/identifiers");
env.addNamespaceDeclaration("xrd", "http://x-road.eu/xsd/xroad.xsd");

// Start by defining client soap header
SOAPElement clientHeader = header.addChildElement("client", "xrd");
clientHeader.addAttribute(env.createQName("objectType", "id"), "SUBSYSTEM");

SOAPElement sdsbInstance = clientHeader.addChildElement("xRoadInstance", "id");
sdsbInstance.addTextNode("FI_TEST");

SOAPElement memberClass = clientHeader.addChildElement("memberClass", "id");
memberClass.addTextNode("GOV");

SOAPElement memberCode = clientHeader.addChildElement("memberCode", "id");
memberCode.addTextNode("1234567-8");

SOAPElement subsystem = clientHeader.addChildElement("subsystemCode", "id");
subsystem.addTextNode("TestClient");


// Service soap header
SOAPElement serviceHeader = header.addChildElement("service", "xrd");
serviceHeader.addAttribute(env.createQName("objectType", "id"), "SERVICE");

sdsbInstance = serviceHeader.addChildElement("xRoadInstance", "id");
sdsbInstance.addTextNode("FI_TEST");

memberClass = serviceHeader.addChildElement("memberClass", "id");
memberClass.addTextNode("GOV");

memberCode = serviceHeader.addChildElement("memberCode", "id");
memberCode.addTextNode("1234567-8");

subsystem = serviceHeader.addChildElement("subsystemCode", "id");
subsystem.addTextNode("DemoService");

SOAPElement serviceCode = serviceHeader.addChildElement("serviceCode", "id");
serviceCode.addTextNode("helloService");

SOAPElement serviceVersion = serviceHeader.addChildElement("serviceVersion", "id");
serviceVersion.addTextNode("v1");

// rest of the header elements
SOAPElement id = header.addChildElement("id", "xrd");
id.addTextNode("ID11234");

SOAPElement userId = header.addChildElement("userId", "xrd");
userId.addTextNode("EE1234567890");

SOAPElement protocolVersion = header.addChildElement("protocolVersion", "xrd");
protocolVersion.addTextNode("4.0");

// Construct the message payload.
SOAPElement operation = body.addChildElement("helloService", "ns1", "http://test.x-road.fi/producer");
SOAPElement operationName = operation.addChildElement("request");
SOAPElement value = operationName.addChildElement("name");
value.addTextNode("Test");
request.saveChanges();

/** Invoke the service endpoint. **/
SOAPMessage response = dispatch.invoke(request);

```

### XRD4J
[XRd4J](https://github.com/petkivim/xrd4j) is a Java library for building X-Road v6 Adapter Servers and clients. This example calls helloService on [X-Road Test Service](https://github.com/petkivim/x-road-test-service)

```java
import com.pkrete.xrd4j.client.SOAPClient;
import com.pkrete.xrd4j.client.SOAPClientImpl;
import com.pkrete.xrd4j.client.deserializer.AbstractResponseDeserializer;
import com.pkrete.xrd4j.client.deserializer.ServiceResponseDeserializer;
import com.pkrete.xrd4j.client.serializer.AbstractServiceRequestSerializer;
import com.pkrete.xrd4j.client.serializer.ServiceRequestSerializer;
import com.pkrete.xrd4j.common.member.ConsumerMember;
import com.pkrete.xrd4j.common.member.ProducerMember;
import com.pkrete.xrd4j.common.message.ServiceRequest;
import com.pkrete.xrd4j.common.message.ServiceResponse;
import com.pkrete.xrd4j.common.util.MessageHelper;
import com.pkrete.xrd4j.common.util.SOAPHelper;

import javax.xml.soap.*;
...
...
String url = "http://localhost:8080/example-adapter-0.0.4-SNAPSHOT/Endpoint";

// Consumer that is calling a service
ConsumerMember consumer = new ConsumerMember("FI_TEST", "GOV", "1234567-8", "TestSystem");

// Producer providing the service
ProducerMember producer = new ProducerMember("FI_TEST", "GOV", "9876543-1", "DemoService", "helloService", "v1");
producer.setNamespacePrefix("ts");
producer.setNamespaceUrl("http://test.x-road.fi/producer");

// Create a new ServiceRequest object, unique message id is generated by MessageHelper.
// Type of the ServiceRequest is the type of the request data (String in this case)
ServiceRequest<String> request = new ServiceRequest<String>(consumer, producer, MessageHelper.generateId());

// Set username
request.setUserId("jdoe");

// Set request data
request.setRequestData("Test message");

// Application specific class that serializes request data
ServiceRequestSerializer serializer = new HelloServiceRequestSerializer();

// Application specific class that deserializes response data
ServiceResponseDeserializer deserializer = new HelloServiceResponseDeserializer();

// Create a new SOAP client
SOAPClient client = new SOAPClientImpl();

// Send the ServiceRequest, result is returned as ServiceResponse object
ServiceResponse<String, String> serviceResponse = client.send(request, url, serializer, deserializer);

// Print out the SOAP message received as response
System.out.println(SOAPHelper.toString(serviceResponse.getSoapMessage()));

// Print out only response data. In this case response data is a String.
System.out.println(serviceResponse.getResponseData());

}

public class HelloServiceRequestSerializer extends AbstractServiceRequestSerializer {

  @Override
  protected void serializeRequest(ServiceRequest request, SOAPElement soapRequest, SOAPEnvelope envelope) throws SOAPException {
      SOAPElement data = soapRequest.addChildElement(envelope.createName("name"));
      data.addTextNode((String) request.getRequestData());
  }
}

public class HelloServiceResponseDeserializer extends AbstractResponseDeserializer<String, String> {
  @Override
  protected String deserializeRequestData(Node requestNode) throws SOAPException {
      for (int i = 0; i < requestNode.getChildNodes().getLength(); i++) {
          if (requestNode.getChildNodes().item(i).getLocalName().equals("name")) {
              return requestNode.getChildNodes().item(i).getTextContent();
          }
      }
      return null;
    }

  @Override
  protected String deserializeResponseData(Node responseNode, SOAPMessage message) throws SOAPException {
      for (int i = 0; i < responseNode.getChildNodes().getLength(); i++) {
          if (responseNode.getChildNodes().item(i).getLocalName().equals("message")) {
              return responseNode.getChildNodes().item(i).getTextContent();
          }
      }
      return null;
  }
}


```
## Javascript
### Using node-soap
[SOAP client for node.js](https://github.com/vpulim/node-soap) is the module being used in this example.

```javascript
var soap = require('soap');
var url = 'http://localhost:8080/example-adapter-0.0.4-SNAPSHOT/Endpoint?wsdl';
var args = {};
soap.createClient(url, function(err, client) {

  client.addSoapHeader({
    "xrd:client": {
      "namespace": "xmlns:tns",
      xRoadInstance: 'FI_TEST',
      memberClass: 'GOV',
      memberCode: '1234567-8',
      subsystemCode: 'TestClient',
      attributes: {
        "id:objectType": 'SUBSYSTEM'
      }
    },
    "xrd:service": {
      xRoadInstance: 'FI_TEST',
      memberClass: 'GOV',
      memberCode: '9876543-1',
      subsystemCode: 'DemoService',
      serviceCode: 'getRandom',
      serviceVersion: 'v1',
      attributes: {
        "id:objectType": 'SERVICE'
      }
    },
    "xrd:id": 'ID11234',
    "xrd:userId": 'EE1234567890',
    "xrd:protocolVersion": '4.0'
    },
    null, null, null
  );
  client.getRandom(args, function(err, result) {
    console.log(result);
  });
});
```

## Documents and links

* [X-Road protocol for adapter server
messaging v4.0](http://esuomi.fi/?mdocs-file=2268&mdocs-url=false)
* [X-Road-tiedonsiirtoprotokolla](http://esuomi.fi/palveluntarjoajille/palveluvayla/tekninen-aineisto/x-road-tiedonsiirtoprotokolla-2/)
