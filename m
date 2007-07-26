Return-Path: <linux-kernel-owner+w=401wt.eu-S933339AbXGZK0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbXGZK0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbXGZK0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:26:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:9777 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbXGZK0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:26:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=s8U/TEQy2sctDCwcH1k1eQ++cZ8QycddcgJuw2AJ4If+s9yrAsHrBAbViwkK+LMmdcFhojgEmTauIHAUFKeH1ItSVbp5GcHYASzLzb+8zvVkMvmJZRyeFnNTZulBLcyffsnBBydHmIc3zc7SJ01s50iY8NbG6MssgiPgs/FIN3k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Date: Thu, 26 Jul 2007 12:22:50 +0200
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Satyam Sharma <satyam.sharma@gmail.com>,
       Rene Herman <rene.herman@gmail.com>, Jos Poortvliet <jos@mijnkamer.nl>,
       david@lang.hm, Nick Piggin <nickpiggin@yahoo.com.au>,
       Valdis.Kletnieks@vt.edu, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, linux-mm@kvack.org,
       Paul Jackson <pj@sgi.com>, Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm> <200707260432.52739.bzolnier@gmail.com> <46A81F67.1040502@garzik.org>
In-Reply-To: <46A81F67.1040502@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707261222.50487.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2007, Jeff Garzik wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 25 July 2007, Ingo Molnar wrote:
> >> you dont _have to_ cooperative with the maintainer, but it's certainly 
> >> useful to work with good maintainers, if your goal is to improve Linux. 
> >> Or if for some reason communication is not working out fine then grow 
> >> into the job and replace the maintainer by doing a better job.
> > 
> > The idea of growing into the job and replacing the maintainer by proving
> > the you are doing better job was viable few years ago but may not be
> > feasible today.
> 
> IMO...  Tejun is an excellent counter-example.  He showed up as an 

IMO this doesn't qualify as a counter-example here et all unless
you are trying to say that Tejun does your job much better and that
we should just replace you. ;)

> independent developer, put a bunch of his own spare time and energy into 
> the codebase, and is probably libata's main engineer (in terms of code 
> output) today.  If I get hit by a bus tomorrow, I think the Linux 
> community would be quite happy with him as the libata maintainer.

Fully agreed on this part.

> > The another problem is that sometimes it seems that independent developers
> > has to go through more hops than entreprise ones and it is really frustrating
> > experience for them.  There is no conspiracy here - it is only the natural
> > mechanism of trusting more in the code of people who you are working with more.
> 
> I think Tejun is a counter-example here too :)  Everyone's experience is 
> different, but from my perspective, Tejun "appeared out of nowhere" 
> producing good code, and so, it got merged rapidly.

Tejun (like any of other developers) spent some time in-the-making
and this time was in large part spent in the IDE-land, and yes I'm also
very glad of the effects. :)

Thanks,
Bart
