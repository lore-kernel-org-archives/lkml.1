Return-Path: <linux-kernel-owner+w=401wt.eu-S932489AbXB1PCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbXB1PCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 10:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932973AbXB1PCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 10:02:54 -0500
Received: from mtl.rackplans.net ([69.90.0.18]:39556 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489AbXB1PCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 10:02:54 -0500
Date: Wed, 28 Feb 2007 10:02:52 -0500 (EST)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Tomas Carnecky <tom@dbservice.com>
cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 SATA error
In-Reply-To: <45E59C07.7020902@dbservice.com>
Message-ID: <Pine.LNX.4.64.0702280959070.28570@mtl.rackplans.net>
References: <fa./FMiSBkno9w078cQXK8Y1+afU50@ifi.uio.no> <45E58FC7.7020102@shaw.ca>
 <Pine.LNX.4.64.0702280936140.28570@mtl.rackplans.net> <45E59C07.7020902@dbservice.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Tomas Carnecky wrote:
> Gerhard Mack wrote:
> > ata1.00: configured for UDMA/100
> > [...]
> > ata1.00: configured for UDMA/66
> > [...]
> > ata1.00: configured for UDMA/44
> > [...]
> > ata1.00: configured for UDMA/33
> > [...]
> > ata1.00: configured for UDMA/25
> > [...]
> > ata1.00: configured for UDMA/16
> > [...]
> > ata1.00: configured for PIO4
> 
> I have the same problem, though it appears randomly. It seems like the chances
> for this happening are bigger if I do heavy disk I/O. The only way to fix that
> is to shut down the computer and wait a few seconds before rebooting (if I
> don't wait, the problem doesn't go away). I bought new harddrives, so it's
> most likely not caused by the drives, I also tried putting the drives onto a
> different controller (I have four on-board SATA controller and two
> harddrives), that didn't help either, so I suspect its the cable - SATA cables
> are very error-prone, I don't trust them as they don't hold that tightly in

Well that's the strange thing.. I've done heavy I/O on this with no 
trouble.  This happened overnight when my system should have been mostly 
idle

	Gerhard

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
