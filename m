Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYIBPCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYIBPCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYIBPCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:02:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39442 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751695AbYIBPCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:02:22 -0400
Date: Tue, 2 Sep 2008 11:02:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thiago Galesi <thiagogalesi@gmail.com>
cc: Alex Buell <alex.buell@munted.org.uk>, <linux-kernel@vger.kernel.org>,
       Robert Hancock <hancockr@shaw.ca>, Tomas Styblo <tripie@cpan.org>,
       <linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
In-Reply-To: <82ecf08e0809020510s2b752d18i6a1901e87effc07a@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0809021101320.2137-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Thiago Galesi wrote:

> Hello
> 
> Does anyone knows of problems concerning 152d:2338 attached to DVD recorders??
> 
> I have one of those here connected to a DVD-RW, it works fine for
> reading, but I can't make it work for recording. K3B produce errors
> while probing, newer cdrecords go as far as burning a CD halfway.
> 
> Here's a bug I opened a couple of months ago
> https://bugzilla.redhat.com/show_bug.cgi?id=440289
> 
> (It really doesn't seem to matter which kernel I'm using - fedora,
> ubuntu or plain vanilla)
> 
> I'll take a closer look at these patches here (and in kernel bug
> 9638), see if they make any difference

If nothing works, you should try usbmon (see 
Documentation/usb/usbmon.txt).

Alan Stern

