Return-Path: <linux-kernel-owner+w=401wt.eu-S1765693AbXHDTAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765693AbXHDTAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765107AbXHDTAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:00:11 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:25547 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760058AbXHDTAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:00:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RpIKnGbk30tZN9XKM7fNGH9NaOWXF8bbneX/0o5yEtijzbr5ycvK31lncMiNKHSyCT53rG0xMubxsr18IsxLrB89OmJN17SRH2G73O+1rA4kK51RfCy5HuY6TTT4XRcZsOUWTmWe+bfRbJMteU+ol9Q6z0dqEx7Re8+/4Sy92KI=
Message-ID: <9a8748490708041200n6bd8ac59x4b45fe5a1177ffc9@mail.gmail.com>
Date: Sat, 4 Aug 2007 21:00:08 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH][RESEND] Clarify the GPL version of contributions by Jesper Juhl in CREDITS
In-Reply-To: <20070804185715.GB28051@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708042031.32704.jesper.juhl@gmail.com>
	 <20070804185715.GB28051@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Aug 04, 2007 at 08:31:32PM +0200, Jesper Juhl wrote:
> > (resending trivial patch, originally from 18/6-2007 02:33)
> >
> >
> > Just to make things clear in the light of recent discussions about
> > licensing.
> > Stuff I contribute to the Linux kernel are licensed under the terms of the
> > GPL version 2.
>
> This really doesn't elong into CREDITS.  If you're not good enough with
> the general GPLv2 stance add additional diclaimers to the files you've
> made changes to (in an extent that is copyrightable)
>

Ok, I can live with that.
I just got paranoid after all the recent GVLv2 vs GPLv3 flamewars and
though it would be best to just add some explicit note somewhere and
couldn't find a more appropriate place than CREDITS to do so.

Feel free to drop this patch...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
