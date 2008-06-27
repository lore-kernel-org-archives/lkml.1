Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbYF0Unh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbYF0Unh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbYF0Un1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:43:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3377 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753544AbYF0Un0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:43:26 -0400
Date: Fri, 27 Jun 2008 16:43:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.6.26-rc1 regression since 2.6.25 - problem in 2.6.26-rc8 again
In-Reply-To: <Pine.LNX.4.44L0.0806271628390.1304-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.44L0.0806271642170.2100-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008, Alan Stern wrote:

> This is very confusing.  It appears that the two usbmon logs don't show 
> the same actions on your part.
> 
> Let's try to keep this as simple as possible.  We'll consider a single 
> fixed course of action:
...
> Do exactly the same thing under both operating system versions, and 
> then we should have suitably comparable logs.

I forgot to mention that you should run these tests under kernels that 
were built with CONFIG_USB_DEBUG enabled, and you should post the two 
dmesg logs along with the usbmon logs.

Alan Stern

