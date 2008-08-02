Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbYHBXtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbYHBXtj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 19:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYHBXtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 19:49:24 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4326 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751476AbYHBXtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 19:49:23 -0400
Date: Sat, 2 Aug 2008 19:49:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Alex Buell <alex.buell@munted.org.uk>
cc: linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       Tomas Styblo <tripie@cpan.org>, <linux-usb@vger.kernel.org>,
       <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
In-Reply-To: <20080801232240.d24166de.alex.buell@munted.org.uk>
Message-ID: <Pine.LNX.4.44L0.0808021948240.18555-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008, Alex Buell wrote:

> On Fri, 1 Aug 2008 22:15:04 +0100, I waved a wand and this message
> magically appears in front of Alex Buell:
> 
> > I've done a lot of mkfs and fsck, haven't seen any problems so far.
> > Fingers crossed that this patch works. 
> 
> Spoke too soon, that patch that was posted doesn't work for me. Here's
> my log:

Which patch?  Several different ones have been posted.

The log doesn't provide much help.  We need to see a log with 
CONFIG_USB_STORAGE_DEBUG enabled.

Alan Stern

