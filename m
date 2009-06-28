Return-Path: <linux-kernel-owner+w=401wt.eu-S1758237AbZF1Qo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbZF1Qo3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbZF1QaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:30:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:52212 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbZF1QaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:30:01 -0400
Date: Sun, 28 Jun 2009 09:29:53 -0700
From: Greg KH <gregkh@suse.de>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Staging: vt6656 ?
Message-ID: <20090628162953.GA28389@suse.de>
References: <a4423d670906090331o6363fe56g34374967f21552e8@mail.gmail.com> <20090609105101.GB15378@suse.de> <20090609113343.GA13779@alittletooquiet.net> <200906281543.12745.bzolnier@gmail.com> <20090628135731.GA9143@alittletooquiet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090628135731.GA9143@alittletooquiet.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 09:57:31AM -0400, Forest Bond wrote:
> Hi,
> 
> On Sun, Jun 28, 2009 at 03:43:12PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > On Tuesday 09 June 2009 13:33:43 Forest Bond wrote:
> > > Hi,
> > > 
> > > On Tue, Jun 09, 2009 at 03:51:01AM -0700, Greg KH wrote:
> > > > On Tue, Jun 09, 2009 at 02:31:30PM +0400, Alexander Beregalov wrote:
> > > > > Hi Greg, Forest
> > > > > 
> > > > > Are you going to merge driver for VT6656 also?
> > > > 
> > > > If someone sends me some patches for it, sure, I will.
> > > 
> > > I have patches almost ready.  I'll send them by the end of next week at the
> > > latest.  Busy week here.
> > 
> > Did I miss the patch?  There are people already doing cleanups for VT6655
> > driver (which seems to share a great deal of code with VT6656 driver) so
> > it would greatly help to get VT6656 merged ASAP and merge the shared code
> > first to not duplicate efforts.
> > 
> > Also if you need some help with integrating the driver or hosting patches
> > in git tree at kernel.org before Greg picks them up [ he seems to be buried
> > alive by patches at the moment :) ] I'll be happy to help..
> 
> I sent it to Greg about two weeks ago.  I assume it is in his queue somewhere.
> 
> Let me know if you think I ought to do something else with them.

Yes, sorry, I am burried in patches right now.  I hope to dig out this
week...

All them are not lost, don't worry.

thanks,

greg k-h
