Return-Path: <linux-kernel-owner+w=401wt.eu-S933678AbXGYQku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933678AbXGYQku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759861AbXGYQkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:40:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:12940 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbXGYQkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:40:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iMYAMMchLNEn/kDAk2i6mn/Xrd645BuowJNkfZQRJyM8uQskzTZb1DNlfviZPpJJnPlf9boHHshLhN911zGjEbPL3BBeGawo304FcYIrq5e1aAhUNRMFDC1zC834oA4mHPhFBhg8q3rw2OlR/VNdPX1qRaNp+MyJRpEJKmtB1Cs=
Message-ID: <b14e81f00707250940r5f83160bia91080d3c93e630b@mail.gmail.com>
Date: Wed, 25 Jul 2007 12:40:39 -0400
From: "Michael Chang" <thenewme91@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [ck] Re: howto get a patch merged (WAS: Re: -mm merge plans for 2.6.23)
Cc: "Kacper Wysocki" <kacperw@online.no>, david@lang.hm,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, Valdis.Kletnieks@vt.edu,
       "Ray Lee" <ray-lk@madrabbit.org>, "Jesper Juhl" <jesper.juhl@gmail.com>,
       linux-kernel@vger.kernel.org, "ck list" <ck@vds.kolivas.org>,
       linux-mm@kvack.org, "Paul Jackson" <pj@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rene Herman" <rene.herman@gmail.com>
In-Reply-To: <20070725160743.GB8284@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <367a23780707250830i20a04a60n690e8da5630d39a9@mail.gmail.com>
	 <20070725160743.GB8284@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Kacper Wysocki <kacperw@online.no> wrote:
>
> > [snip howto get a patch merged]
>
> > > But a "here is a solution, take it or leave it" approach, before
> > > having communicated the problem to the maintainer and before having
> > > debugged the problem is the wrong way around. It might still work
> > > out fine if the solution is correct (especially if the patch is
> > > small and obvious), but if there are any non-trivial tradeoffs
> > > involved, or if nontrivial amount of code is involved, you might see
> > > your patch at the end of a really long (and constantly growing)
> > > waiting list of patches.
> >
> > Is that what happened with swap prefetch these two years? The approach
> > has been wrong?
>
> i dont know - but one of the maintainers of the code (Nick) says that he
> asked for but did not get debug feedback:

Perhaps this is unimportant now, I don't know, but who did he ask?
Where did he ask? Where should the feedback have gone? (For example,
is he subscribed to -ck?) To be perfectly honest, I find this very
surprising, considering the number of people that appear to be
supporting this patch. I can only wonder whether it's possible this
request never got to any of them.

-- 
Michael Chang

Please avoid sending me Word or PowerPoint attachments. Send me ODT,
RTF, or HTML instead.
See http://www.gnu.org/philosophy/no-word-attachments.html
Thank you.
