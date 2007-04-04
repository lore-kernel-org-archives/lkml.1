Return-Path: <linux-kernel-owner+w=401wt.eu-S2992994AbXDDQiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992994AbXDDQiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992986AbXDDQiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:38:09 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42784 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992994AbXDDQiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:38:07 -0400
Date: Wed, 4 Apr 2007 18:38:07 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Rene Herman <rene.herman@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
Message-ID: <20070404163807.GO27660@stusta.de>
References: <46138B4C.2050409@gmail.com> <20070404123311.GA18552@infradead.org> <4613A1F1.2080007@gmail.com> <20070404145726.GD27660@stusta.de> <4613D342.3040501@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4613D342.3040501@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 06:33:06PM +0200, Stefan Richter wrote:
> Adrian Bunk wrote:
> > On Wed, Apr 04, 2007 at 03:02:41PM +0200, Rene Herman wrote:
> >> Given modules with multiple authors, current and non-current, I believe 
> >> having "modinfo -m" tell the user whom to contact is an avantage.
> > 
> > Much bigger problems are:
> > - Who will maintain this information properly?
> > - What about modules that are maintained implicitely by the subsystem
> >   maintainer?
> > 
> > And often a user can't be expected to locate the source of a problem, or 
> > it might not be in a driver but in a subsystem.
> > 
> > For vendor kernels, the user should contact the vendor.
> > For ftp.kernel.org kernels, I don't see any better solution than telling 
> > people to report problems to linux-kernel or the kernel Bugzilla and 
> > routing them further from here.
> 
> Generelly it has to be kept in mind that there are different contacts
> for different purposes:
>   - usage problems --> get in touch with the _support_
>   - bug reports --> get in touch with _maintainers_

- bug reports against vendor kernels -> get in touch with the _vendor_
  (the vendor might ship a heavily patched driver in an ancient kernel)

>   - development --> get in touch with maintainers/ kernel hackers/
>     copyright holders...
> 
> The Amiga keyboard had a [Help] key, but this is not how it works.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

