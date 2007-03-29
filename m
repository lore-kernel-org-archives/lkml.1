Return-Path: <linux-kernel-owner+w=401wt.eu-S1030725AbXC2U7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030725AbXC2U7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 16:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030732AbXC2U7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 16:59:50 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:16406 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030725AbXC2U7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 16:59:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=kxBZN6tV/z8ZBb1RZ7JhW01NyjMpPHq/6wq18P6LUKalJjlgb+IXGOfT3N9QDkI3I2fTLeGB45U4vzezsYGRfl5ED2UimH3fwtPE5gMNDnH+/1PwkWQ6Smw96OpmXuWiI1hZkwu+WMDXKq4Ykfp74okRao98u2pFOlhEty6cHFY=
Date: Thu, 29 Mar 2007 22:59:36 +0200
To: Cong WANG <xiyou.wangcong@gmail.com>
Cc: Russ Meyerriecks <datachomper@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Student Project Ideas
Message-ID: <20070329205935.GB13541@Ahmed>
References: <bc8960410703290304t7ff61205u7110ac33c671fb4d@mail.gmail.com> <2375c9f90703290332w3f232b1cjf044f554fba04879@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2375c9f90703290332w3f232b1cjf044f554fba04879@mail.gmail.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 06:32:21PM +0800, Cong WANG wrote:
> 2007/3/29, Russ Meyerriecks <datachomper@gmail.com>:
> >Hi all,
> >  I've been hacking on the Linux kernel all semester for my OS:
> >Internals class. We are given full autonomy in picking our final
> >programming project and I would love for mine to be /useful/ for the
> >Linux kernel and not just a theoretical exorcise. If anybody has any
> >bug fixes or features maybe they never got around to, and would be
> >suitable for this situation, I would love to hear about them.
> >
> 
> First, I think you can read the book named "Kernel Projects for
> Linux". It's a good book although it's outdated.
> 
> Second, in fact, I am also a college student and also want to find a
> suitable and real task in linux kernel for me to work on. KJ doesn't
> help much. ;-p
> 

No, it really helps alot, just be _patient_. For me, I sent a series of dumb
patches at first to use ARRAY_SIZE macro instead of manual computation. Though
the patches were completely braindead, I learnt alot of stuff about how
everything works here. 

Beside sending this KJ patches, I keep reading from Understanding Linux kernel v3
and reading lots of code everyday. Yesterday my first semi-real patch was
accepted in -mm. I'm sure that day by day my patches will be more real and fix
serious issues. 

All of that wouldn't have smoothly happened without the first step, the KJ step ;).

It seems that being a developer in the kernel community is going exactly like how
code goes, _evolution_ not a revolution. You can't be responsible for a good
project directly, just take your way from a janitor to a subsystem maintaner :).
Ofcourse, unless you have an old experience in other OSs (espcifically Unix ones).

Regards,

-- 
Ahmed S. Darwish
http://darwish.07.googlepages.com

