Return-Path: <linux-kernel-owner+w=401wt.eu-S1751071AbXBZCW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071AbXBZCW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 21:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbXBZCW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 21:22:57 -0500
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:58207 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751069AbXBZCW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 21:22:56 -0500
Date: Sun, 25 Feb 2007 21:22:54 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Sarah Bailey <saharabeara@gmail.com>, <usb-hacking@svcs.cs.pdx.edu>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] usbfs2: Why asynchronous I/O?
In-Reply-To: <20070225235556.GA28748@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0702252119520.29377-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Feb 2007, Greg KH wrote:

> On Sun, Feb 25, 2007 at 11:51:46AM -0500, Alan Stern wrote:
> > This deserves to be discussed on LKML.
> 
> Are you sure?  I thought it already got pretty well answered on the USB
> mailing list (see David's response for one such response.)

Well, I was sure at the time I forwarded the message, which was hours 
before David's response arrived.

Besides, Sarah's message did bring up issues of interest to the kernel 
community at large, such as why AIO is supported by so few drivers.

Alan Stern

