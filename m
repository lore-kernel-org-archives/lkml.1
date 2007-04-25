Return-Path: <linux-kernel-owner+w=401wt.eu-S1161024AbXDYA3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161024AbXDYA3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 20:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030811AbXDYA3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 20:29:51 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33415 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030419AbXDYA3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 20:29:50 -0400
Date: Wed, 25 Apr 2007 02:29:58 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Wolfgang Erig <Wolfgang.Erig@gmx.de>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [1/3] 2.6.21-rc7: known regressions (v2)
Message-ID: <20070425002958.GR3468@stusta.de>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070423214847.GB3468@stusta.de> <20070423221819.GA7218@kroah.com> <20070424093253.GA1075@erig.dyndns.org> <20070425001428.GA1366@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070425001428.GA1366@kroah.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 05:14:28PM -0700, Greg KH wrote:
> On Tue, Apr 24, 2007 at 11:32:53AM +0200, Wolfgang Erig wrote:
> > On Mon, Apr 23, 2007 at 03:18:19PM -0700, Greg KH wrote:
> > > On Mon, Apr 23, 2007 at 11:48:47PM +0200, Adrian Bunk wrote:
> > > > This email lists some known regressions in Linus' tree compared to 2.6.20.
> > > > 
> > > > If you find your name in the Cc header, you are either submitter of one
> > > > of the bugs, maintainer of an affectected subsystem or driver, a patch
> > > > of you caused a breakage or I'm considering you in any other way
> > > > possibly involved with one or more of these issues.
> > > > 
> > > > Due to the huge amount of recipients, please trim the Cc when answering.
> > > > 
> > > > 
> > > > Subject    : gammu no longer works
> > > > References : http://lkml.org/lkml/2007/4/20/84
> > > > Submitter  : Wolfgang Erig <Wolfgang.Erig@gmx.de>
> > > > Status     : unknown
> > > 
> > > I've asked for more information about this, and so far am not sure it's
> > > a real problem.
> > 
> > It is a real problem for me.
> > I tried this on 2 different boxes with the same behaviour.
> > No sync between my Nokia mobile and Linux with the latest kernel :(
> 
> Sorry, I didn't see your response, have followed up on lkml now.

It turned out this was actually a bug in Gammu that will be fixed in 
the next release of Gammu.

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

