describe "Notification.Display", ->
  it "generateLogo returns the weather image tag", ->
    imageHtml = Notification.Display.generateLogo({dataId: "template-logo", class: "some-class"})
    expect(imageHtml).toBeMatchedBy('[data-id=template-logo]')
    expect(imageHtml).toBeMatchedBy('.some-class')
