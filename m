Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbXAXUGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbXAXUGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbXAXUGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:06:42 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:2901 "HELO
	mailout.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752018AbXAXUGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:06:41 -0500
Date: Wed, 24 Jan 2007 21:06:48 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       takada <takada@mbf.nifty.com>, Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: 2.6.20-rc5: known unfixed regressions (v3) (part 2)
Message-ID: <20070124200648.GN17836@stusta.de>
References: <Pine.LNX.4.64.0701121424520.11200@woody.osdl.org> <20070124154725.GK17836@stusta.de> <20070124160631.GE7582@csclub.uwaterloo.ca> <20070124163801.GM17836@stusta.de> <20070124165708.GF7582@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124165708.GF7582@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 11:57:09AM -0500, Lennart Sorensen wrote:
> On Wed, Jan 24, 2007 at 05:38:01PM +0100, Adrian Bunk wrote:
> > Was the removed
> >   setCx86(CX86_CCR3, ccr3);
> > without any effects?
> 
> I didn't think that was ever checked in.  I thought the patch was still
> being discussed.
>...

As I wrote in my list, it is commit e4f0ae0ea63caceff37a13f281a72652b7ea71ba 
in Linus' tree.

> Len Sorensen

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

