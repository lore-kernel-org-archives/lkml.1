Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbXL2WPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbXL2WPk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 17:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbXL2WPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 17:15:33 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1671 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751600AbXL2WPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 17:15:32 -0500
Date: Sat, 29 Dec 2007 17:15:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: mgross <640e9920@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: [RFC] USB driver for talking to the Microchip PIC18 boot loader
In-Reply-To: <20071229193409.GA20188@mgross-t43>
Message-ID: <Pine.LNX.4.44L0.0712291714041.26261-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Dec 2007, mgross wrote:

> I'm playing around with a PIC based project at home (not an Intel
> activity) and found I needed a usb driver to talk to the boot loader
> so I can program my USB Bitwhacker with new custom firmware.  The
> following adds the pic18bl driver to the kernel.  Its pretty simple
> and is somewhat based on bits of a libusb driver that does some of
> what this driver does.
> 
> What do you think?

Not to detract from your driver, but would it be possible to do the 
whole thing in userspace using libusb?  Maybe by extending the driver 
you mentioned?

Alan Stern

