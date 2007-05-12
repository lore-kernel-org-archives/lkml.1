Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbXELMid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbXELMid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 08:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756112AbXELMi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 08:38:26 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45466 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755656AbXELMi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 08:38:26 -0400
Date: Sat, 12 May 2007 14:38:27 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       Rene Herman <rene.herman@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, randy.dunlap@oracle.com,
       akpm@linux-foundation.org, rpjday@mindspring.com, marcel@holtmann.org,
       hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module_author: don't advice putting in an email address
Message-ID: <20070512123827.GN7984@stusta.de>
References: <4643BDF2.9030105@gmail.com> <20070511114605.4c2698ec@the-village.bc.nu> <alpine.DEB.0.98.0705110740420.12363@sigma.j-a-k-j.com> <20070511211823.GG7984@stusta.de> <20070511223500.01fe6596@the-village.bc.nu> <20070512071455.GH7984@stusta.de> <20070512131530.5258d588@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070512131530.5258d588@the-village.bc.nu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 01:15:30PM +0100, Alan Cox wrote:
> > > I'd prefer not. I get reports from people about drivers that got "lost"
> > > by vendors, regularly. Nor am I pointing fingers at specific vendors here,
> > > last month I sorted out a two year old "lost in Red Hat Bugzilla" kernel
> > > bug for example.
> > 
> > How many maintainers want to get bug reports against the kernel 2.6.9 
> > shipped with RHEL 4?
> 
> The enterprise kernels which tend to be the ones with the long lag also
> have a userbase with support contracts so tend not to consider l/k as
> their first support stop anyway.

Not if they use it through CentOS...

And Debian has the same problem with similar old kernels
(Debian 3.1 that was the latest stable release until one month ago and 
 is still supported for one year ships with 2.6.8).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

