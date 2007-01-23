Return-Path: <linux-kernel-owner+w=401wt.eu-S933137AbXAWUz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137AbXAWUz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 15:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933135AbXAWUz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 15:55:57 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:3369 "HELO
	mailout.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933137AbXAWUz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 15:55:56 -0500
Date: Tue, 23 Jan 2007 21:56:00 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: 2.6.18-stable release plans?
Message-ID: <20070123205600.GD17836@stusta.de>
References: <45B53722.9030206@redhat.com> <9a8748490701221623q1b61f03fva7b0ad7e7f30316f@mail.gmail.com> <45B6712C.2030901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B6712C.2030901@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 03:33:48PM -0500, Chuck Ebbert wrote:
> Jesper Juhl wrote:
> > On 22/01/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> >> Is there going to be another 2.6.18-stable release?
> >>
> >
> > Now that 2.6.19 is out, most likely not.  -stable releases are made
> > for the latest stable 2.6.x kernel, once 2.6.x+1 is out that's the one
> > -stable patches are made for (2.6.16 is an exception)..
> >
> Great... just as 2.6.18 approaches actual stability.
> 
> Adrian, how much longer are you going to support 2.6.16? Would you consider
> moving to 2.6.18 any time soon?

I'll continue to maintain 2.6.16 - moving to 2.6.18 or any other kernel 
would defeat the purpose of what I am doing.

I'm not yet decided whether I'll create other stable kernel branches, 
but it this will happen it won't be 2.6.18, more like 2.6.25 or 2.6.30.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

