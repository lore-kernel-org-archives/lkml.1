Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbZF1Pxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbZF1Pxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 11:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZF1Pxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 11:53:48 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64306 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZF1Pxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 11:53:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=R/5bgeHGlc+/UXz02ZjLD4GBsSoXJ0Z1ZbPAmXzATR+4EpWZNbq3hPWl5QEAlAt9p/
         K+5IBPihFooYqinQjw/8NxqzaoH9CVlkuMd9HtZZ8A68UoiddxvVOJph6mIrEUHoSngs
         lUWjHY8DbkE4JaIv0ShutZKqP/4xSIg+H3U9g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>
Subject: Re: Staging: vt6656 ?
Date: Sun, 28 Jun 2009 17:59:45 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: Greg KH <gregkh@suse.de>, Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <a4423d670906090331o6363fe56g34374967f21552e8@mail.gmail.com> <200906281543.12745.bzolnier@gmail.com> <20090628135731.GA9143@alittletooquiet.net>
In-Reply-To: <20090628135731.GA9143@alittletooquiet.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906281759.46152.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 June 2009 15:57:31 Forest Bond wrote:
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

There seems to be a lot of stuff in his queue.. ;)

> Let me know if you think I ought to do something else with them.

Please re-post with cc:ing linux-kernel so people looking for them (i.e. me)
can pick them up from the list if needed (please also cc: lkml on all patches
in the future, thanks!).

[ I'll later setup vt665x branch of my misc.git tree, merge your patches,
  merge all outstanding vt6655 patches from Alexander and investigate a bit
  more whether merge of vt665x drivers is feasible and what needs to be
  done if so.. ]

Thanks.
Bart
