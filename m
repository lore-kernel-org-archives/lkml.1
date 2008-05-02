Return-Path: <linux-kernel-owner+w=401wt.eu-S934337AbYEBLQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337AbYEBLQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758438AbYEBLQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:16:08 -0400
Received: from mtl.rackplans.net ([69.90.0.18]:43933 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbYEBLQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:16:07 -0400
Date: Fri, 2 May 2008 07:16:03 -0400 (EDT)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, James Smart <James.Smart@Emulex.Com>,
       linux-scsi@vger.kernel.org
Subject: Re: [2.6.25] lpfc driver problem
In-Reply-To: <20080501211659.8a2e0686.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0805020714500.21142@mtl.rackplans.net>
References: <alpine.DEB.1.10.0804291625330.31652@mtl.rackplans.net> <20080501211659.8a2e0686.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Tue, 29 Apr 2008 16:28:03 -0400 (EDT) Gerhard Mack <gmack@innerfire.net> wrote:
> 
> > hello
> > 
> > I'm getting the following error when trying to load the lpfc driver.  This 
> > is a new install so I have no idea if this is a regression or not.
> > 
> > dmesg output:
> > Emulex LightPulse Fibre Channel SCSI driver 8.2.5
> > Copyright(c) 2004-2008 Emulex.  All rights reserved.
> > scsi2 :  on PCI bus 02 device 50 irq 24
> > lpfc 0000:02:0a.0: 0:0436 Adapter failed to init, timeout, status reg 
> > x400000, FW Data: A8 x0 AC x0
> > lpfc 0000:02:0a.0: 0:0436 Adapter failed to init, timeout, status reg 
> > x400000, FW Data: A8 x0 AC x0
> > 
> > Card is:
> > 02:0a.0 Fibre Channel: Emulex Corporation LP8000 Fibre Channel Host 
> > Adapter (rev 02)
> > 02:0a.0 0c04: 10df:f800 (rev 02)
> 
> (Cc's added)

I am no longer able to debug this.  My client took the card back and 
traded it for a Qlogic.

	Gerhard
 

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
