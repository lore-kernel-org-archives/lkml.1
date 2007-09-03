Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbXICL5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbXICL5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 07:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbXICL5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 07:57:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:48942 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbXICL5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 07:57:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qnexDQg+s90hVfOfhyAMEoCZXbAw8aDKw20zVPvPyK26dgqemdpCrNWEJ7MWRr4XZk5a5e+hppuilWIqLK7Fmmr2mN4LgDUYPRcVrfONrwN9ZhnU5YhSb1EOdBdHHWqW0/mtX6OxSbqJb4+tT9sy6Kn5n0a5QwQoo9OP9rTupqA=
Message-ID: <9b23fc710709030457l4286781es81ae4c45c4716462@mail.gmail.com>
Date: Mon, 3 Sep 2007 17:27:23 +0530
From: "Renuka Pampana" <prenuka@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: query regarding usb-hotplug
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

 iam having one doubt about the usb driver application. i written one
small application  (u can see this file usbthread.c
in attachment , cc -o usbthread usbthread.c -lpthread -lusb (for
compilation) ) on usb device drivers using LIBUSB-0.1.12
in user space. my project leader has given one task about the usb
device drivers in user space. so using lib usb library and
written application in user space. we are getting out put as device
properties in userspace. but we are using polling
mechanism ( declaring one thread and calling one usb function as
subroutine in thread, this thread calling usb function
 continuously and it  has put in  infinity loop). but my task have to
develop  this same application with out using poling.

i heared an event mechanism for with out polling. but i dont know how
to develop event mechanism.

plz give me any idea to develop the hot plugging system by using event
mechanism...

i hope to get reply as soon as possible .

thanks and regards,
Raman.A
09916485129
