Return-Path: <linux-kernel-owner+w=401wt.eu-S1759236AbYEMJSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbYEMJSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYEMJSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:18:31 -0400
Received: from ns.store20.com ([212.7.7.16]:43375 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbYEMJSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:18:31 -0400
Subject: Re: OOPS in ov511 driver
From: Priit Laes <plaes@plaes.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: USB list <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, mmcclell@bigfoot.com
In-Reply-To: <200805131107.13958.oliver@neukum.org>
References: <1210666197.30196.7.camel@localhost>
	 <200805131107.13958.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Date: Tue, 13 May 2008 12:18:36 +0300
Message-Id: <1210670316.11544.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ühel kenal päeval, T, 2008-05-13 kell 11:07, kirjutas Oliver Neukum:
> Am Dienstag 13 Mai 2008 10:09:57 schrieb Priit Laes:
> > Hey!
> > 
> > I got following oops when unplugging some Creative-labeled webcam using
> > ov511 driver. Machine is Core2 Duo 64-bit, Gentoo Linux, kernel is
> > 2.6.25-05301-gc3bf9bc, gcc is 4.2.3 (Gentoo 4.2.3 p1.0)
> > 
> > usb 2-1: USB disconnect, address 7
> > ov511: ERROR: urb->status=-108: Unknown
> > ov511: usb_submit_urb() ret -19
> > ov511: ERROR: urb->status=-108: Unknown
> > ov511: usb_submit_urb() ret -19
> > usb 2-1: new full speed USB device using uhci_hcd and address 8
> > usb 2-1: configuration #1 chosen from 1 choice
> > ov511: USB OV511+ video device found
> > ov511: model: Creative Labs WebCam 3
> > ov511: Sensor is an OV7620
> > ov511: Device at usb-0000:00:1d.0-1 registered to minor 0
> 
> Are you replugging the device?

Yeah, when looking at the dmesg output, probably something like this
happened.
