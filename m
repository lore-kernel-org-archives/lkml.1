Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbZGGR2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbZGGR2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZGGR2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:28:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34340 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754028AbZGGR2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:28:11 -0400
Date: Tue, 7 Jul 2009 13:28:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Michael S. Zick" <lkml@morethan.org>
cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Null Pointer BUG in uhci_hcd
In-Reply-To: <200907071043.37550.lkml@morethan.org>
Message-ID: <Pine.LNX.4.44L0.0907071325580.8221-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Michael S. Zick wrote:

> > It looks like there's a serious problem in your UHCI hardware.  
> > According to the log you posted, it's not working at all.
> > 
> 
> I am using the x86-generic drivers - -

Not a problem with the drivers, a problem in the hardware.

> There are VIA-device specific drivers in other arch trees,
> (arm?, powerpc?) - I haven't compared them to the x86-generic
> to see if they had to do something specific for 1106:3038, 1106:3104
> 
> Any idea if those drivers are "long dead" or still in use?

I don't know what drivers you're talking about.

Alan Stern

