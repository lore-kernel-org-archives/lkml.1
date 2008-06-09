Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbYFISR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbYFISR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYFISRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:17:17 -0400
Received: from senator.holtmann.net ([87.106.208.187]:39811 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbYFISRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:17:16 -0400
Subject: Re: 26-rc5+git hang on boot bluetooth hidd/hid_devices
From: Marcel Holtmann <marcel@holtmann.org>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1213029509.4521.29.camel@localhost>
References: <1213015948.7018.48.camel@localhost>
	 <1213022913.17870.4.camel@violet.holtmann.net>
	 <1213029509.4521.29.camel@localhost>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 20:19:54 +0200
Message-Id: <1213035594.17870.6.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soeren,

> > > updating to 2.6.26-rc5+git I recognize that debian sid suddenly hangs on
> > > boot when bluetooth is activated. The last message I see is starting
> > > hidd/hid_devices. And well 2.6.24/25 boot.
> > > 
> > > Does anybody else observe this? Any ideas?
> > 
> > is HID2HCI switching utility on? Do you have a HID proxy adapter in your
> > system? If yes, then it is actually an USB issue.
> 
> yes hid2hci is on as this system is a macbookpro that tends to forget
> that it has internal bluetooth after resume (if resume even works)

then please disable hid2hci and see if it still has a problem and report
this to the USB guys.

Regards

Marcel


