Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbXAXQh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbXAXQh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 11:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbXAXQh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 11:37:57 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:2213 "HELO
	mailout.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752004AbXAXQh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 11:37:56 -0500
Date: Wed, 24 Jan 2007 17:38:01 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       takada <takada@mbf.nifty.com>, Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: 2.6.20-rc5: known unfixed regressions (v3) (part 2)
Message-ID: <20070124163801.GM17836@stusta.de>
References: <Pine.LNX.4.64.0701121424520.11200@woody.osdl.org> <20070124154725.GK17836@stusta.de> <20070124160631.GE7582@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124160631.GE7582@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 11:06:31AM -0500, Lennart Sorensen wrote:
> On Wed, Jan 24, 2007 at 04:47:25PM +0100, Adrian Bunk wrote:
> > Subject    : fix geode_configure()
> > References : http://lkml.org/lkml/2007/1/9/216
> > Submitter  : Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
> > Caused-By  : takada <takada@mbf.nifty.com>
> >              commit e4f0ae0ea63caceff37a13f281a72652b7ea71ba
> > Handled-By : takada <takada@mbf.nifty.com>
> >              Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
> > Status     : patches are being discussed
> 
> I wouldn't call this a regression.  It appears to go way back.  I also
> didn't find it, I just commented on it since it does affect the platform
> I work on.

Was the removed
  setCx86(CX86_CCR3, ccr3);
without any effects?

> Len Sorensen

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

