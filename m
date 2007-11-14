Return-Path: <linux-kernel-owner+w=401wt.eu-S1764257AbXKNBQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764257AbXKNBQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759024AbXKNBPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:15:50 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:17514 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761969AbXKNBPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:15:49 -0500
Date: Tue, 13 Nov 2007 17:15:07 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kevin Winchester <kjwinchester@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-11-13-04-14.tar.gz uploaded
Message-Id: <20071113171507.8ce6ba1b.randy.dunlap@oracle.com>
In-Reply-To: <20071113171113.06f2b26f.akpm@linux-foundation.org>
References: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
	<200711132020.33124.kjwinchester@gmail.com>
	<20071113171113.06f2b26f.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 17:11:13 -0800 Andrew Morton wrote:

> On Tue, 13 Nov 2007 20:20:32 -0400 Kevin Winchester <kjwinchester@gmail.com> wrote:
> 
> > On November 13, 2007 08:15:41 am akpm@linux-foundation.org wrote:
> > > The mm snapshot broken-out-2007-11-13-04-14.tar.gz has been uploaded to
> > >
> > >   
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-11-13-
> > >04-14.tar.gz
> > >
> > > It contains the following patches against 2.6.24-rc2:
> > >
> > 
> > <snip>
> > 
> > How exactly do I go about trying out this snapshot?  I did the following:
> > 
> > - exported 2.6.24-rc2 from my cloned git tree to a separate folder
> > - installed quilt
> > - extracted the patches to the "patches" directory at the top level of the 
> > 2.6.24-rc2 tree
> > - copied the list of patches from your mail into a "series" file which I 
> > placed in the "patches" directory
> 
> The tarball contains a copy of the series file.  For some reason LARGE
> numbers of people miss it and ask me "hey, where's the series file?".  Odd.

Raises hand.


> >  Is 
> > there a reason that there is no "series" file in the archive with the 
> > patches?
> 
> It's in there ;)
> 
> btw, I put the patches in a directory called "broken-out" so that you can
> untar them in your kernel tree and not have them stomped all over your
> existing patches/ directory.  symlink it...

It's not at the same directory level as the patches.  For some reason,
that would help me find it.

---
~Randy
