(function() {
  describe("Notification.Display", function() {
    return it("generateLogo returns the weather image tag", function() {
      var imageHtml;
      imageHtml = Notification.Display.generateLogo({
        dataId: "template-logo",
        "class": "some-class"
      });
      expect(imageHtml).toBeMatchedBy('[data-id=template-logo]');
      return expect(imageHtml).toBeMatchedBy('.some-class');
    });
  });

}).call(this);
