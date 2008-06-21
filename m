Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbYFUSrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbYFUSrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 14:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYFUSrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 14:47:10 -0400
Received: from nn7.de ([85.214.94.156]:60996 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbYFUSrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 14:47:09 -0400
Subject: Re: hdparm -M acoustic management for sata disks?
From: Soeren Sonnenburg <kernel@nn7.de>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200806212034.24059.linux@rainbow-software.org>
References: <1214043295.17302.16.camel@localhost> <485D098E.3080109@rtr.ca>
	 <1214066456.18959.6.camel@localhost>
	 <200806212034.24059.linux@rainbow-software.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 21 Jun 2008 20:46:59 +0200
Message-Id: <1214074019.18959.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-21 at 20:34 +0200, Ondrej Zary wrote:
> On Saturday 21 June 2008 18:40:56 Soeren Sonnenburg wrote:
> > On Sat, 2008-06-21 at 10:00 -0400, Mark Lord wrote:
> > > Soeren Sonnenburg wrote:
> > > > Dear all,
> > > >
> > > > why is acoustic management via hdparm not supported for sata
> disks?
> > > [...]
> > # hdparm -M 128 /dev/sda
> >
> > /dev/sda:
> >  setting acoustic management to 128
> >  HDIO_DRIVE_CMD:ACOUSTIC failed: Input/output error
> >  acoustic      = not supported
> >
> 
> Aren't they Seagate drives? They're known not to support acoustic management.

Yes all of them were seagate drives.

So just bad luck... I should simply not have exchanged that noise fan -
now I head the hard-disks seeking...

Am I guessing right that samsung, hitachi et.al just do have support for
AAM?

Soeren
