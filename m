Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbXKEVta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbXKEVta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 16:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbXKEVtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 16:49:23 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47477 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752659AbXKEVtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 16:49:23 -0500
Date: Mon, 5 Nov 2007 16:49:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices (fwd)
In-Reply-To: <1193848942.6621.18.camel@lov.site>
Message-ID: <Pine.LNX.4.44L0.0711051644580.2800-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg:

So what's our status?  Do you think it's worthwhile adding the 
"drop reference to parent kobject at remove time instead of release 
time" patch?

Also, what's the story on the updates to the USB uevent routines?  Do 
you want separate patches from Kay and me or should we combine them 
into a single patch?

Alan Stern

