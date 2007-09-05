Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbXIEGuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbXIEGuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 02:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbXIEGuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 02:50:32 -0400
Received: from canuck.infradead.org ([209.217.80.40]:50993 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbXIEGuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 02:50:32 -0400
Date: Tue, 4 Sep 2007 23:17:53 -0700
From: Greg KH <greg@kroah.com>
To: Renuka Pampana <prenuka@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: query regarding usb-hotplug
Message-ID: <20070905061753.GA31005@kroah.com>
References: <9b23fc710709030457l4286781es81ae4c45c4716462@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b23fc710709030457l4286781es81ae4c45c4716462@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 05:27:23PM +0530, Renuka Pampana wrote:
> hi all,
> 
>  iam having one doubt about the usb driver application. i written one
> small application  (u can see this file usbthread.c
> in attachment 

Nothing was attached :(


> , cc -o usbthread usbthread.c -lpthread -lusb (for
> compilation) ) on usb device drivers using LIBUSB-0.1.12
> in user space. my project leader has given one task about the usb
> device drivers in user space. so using lib usb library and
> written application in user space. we are getting out put as device
> properties in userspace. but we are using polling
> mechanism ( declaring one thread and calling one usb function as
> subroutine in thread, this thread calling usb function
>  continuously and it  has put in  infinity loop). but my task have to
> develop  this same application with out using poling.
> 
> i heared an event mechanism for with out polling. but i dont know how
> to develop event mechanism.
> 
> plz give me any idea to develop the hot plugging system by using event
> mechanism...
> 
> i hope to get reply as soon as possible .

Try asking this on the libusb mailing list, the developers there should
be able to help you out.

good luck,

greg k-h
