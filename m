Return-Path: <linux-kernel-owner+w=401wt.eu-S1764438AbYHDUpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764438AbYHDUpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763190AbYHDUpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:45:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41765 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1764078AbYHDUpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:45:09 -0400
Date: Mon, 4 Aug 2008 16:45:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alex Buell <alex.buell@munted.org.uk>
cc: linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       Tomas Styblo <tripie@cpan.org>, <linux-usb@vger.kernel.org>,
       <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
In-Reply-To: <20080804211706.81d4aafa.alex.buell@munted.org.uk>
Message-ID: <Pine.LNX.4.44L0.0808041644240.2152-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008, Alex Buell wrote:

> On Mon, 4 Aug 2008 12:48:09 -0400 (EDT), I waved a wand and this
> message magically appears in front of Alan Stern:
> 
> > > Which patch should I be trying out? 
> > 
> > That's the right patch.  You should use it with 2.6.27-rc1.
> 
> I used that with 2.6.25, works perfectly with PATA devices. I think
> maybe the SATA device I have is bad, I have another one I'll try out
> later tonight. 

I meant what I said about 2.6.27-rc1.  There have been other changes 
which will affect the patch's operation.

Alan Stern

