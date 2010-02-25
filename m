Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934269Ab0BYWXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:23:47 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58313 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934190Ab0BYWXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:23:46 -0500
Date: Thu, 25 Feb 2010 17:23:45 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>
cc: Sarah Sharp <sarah.a.sharp@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device
 8087:0020
In-Reply-To: <4B86E62E.3090606@maroy.hu>
Message-ID: <Pine.LNX.4.44L0.1002251722200.1383-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010, Ákos Maróy wrote:

> BTW, any ideas on why suspend works with unloading xhci, but hibernate
> not working?

That's a power management issue, not a USB problem.  Rafael may be able 
to help you.  You'll probably want to start a new email thread on the 
linux-pm mailing list.

Alan Stern

