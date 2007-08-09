Return-Path: <linux-kernel-owner+w=401wt.eu-S934461AbXHIIB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934461AbXHIIB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 04:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbXHIIBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 04:01:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:21758 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbXHIIBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 04:01:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mGTs+cpS3N3ak47Uh3CEFyory99w6lkePzPIMJD3cTrwKtwEK4h8jsiB6Je+liCHNrYia53oHYwRxK1N71h1WxQkchP1bEgBm1mFNqjgEkoBy/h5yDpz8pDQ2l4V7WTAeCJrurX374pj4K9T7PHvhWm8YPAGbG83NhTzsPTYWE4=
Message-ID: <d592e5da0708090101q4ba81470s5a6d02fcd11837bd@mail.gmail.com>
Date: Thu, 9 Aug 2007 11:01:15 +0300
From: "jonatan perry" <jonatan44@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: usb device module probing
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello,
i have a linux kernel usb module driver and would like to probe it,
i'v worked by the usbled.c file and didn't understand who the
   led_probe(struct usb_interface *interface, const struct usb_device_id *id)
function receive it's paramerts, the struct have the
  .probe =	led_probe,
filed and called by the
  static int __init usb_led_init(void)
but who the function receives the parameters?

thanks.
