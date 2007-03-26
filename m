Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbXCZSM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbXCZSM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbXCZSM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:12:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43396 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753632AbXCZSM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:12:27 -0400
Date: Mon, 26 Mar 2007 14:12:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tino Keitel <tino.keitel@gmx.de>
cc: Oliver Neukum <oneukum@suse.de>, <linux-usb-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] possible USB regression with 2.6.21-rc4: iPod
 doesn't work
In-Reply-To: <20070325165312.GA5311@dose.home.local>
Message-ID: <Pine.LNX.4.44L0.0703261410460.4848-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007, Tino Keitel wrote:

> > Please recompile
> > with CONFIG_USB_DEBUG
> > and without CONFIG_USB_SUSPEND
> 
> With CONFIG_USB_SUSPEND disabled, the iPod works. The dmesg output is
> attached.

In fact, both logs (with and without CONFIG_USB_SUSPEND) show the iPod 
working.  Can you post a log with CONFIG_USB_DEBUG turned on that shows 
any errors?

Alan Stern

