Return-Path: <linux-kernel-owner+w=401wt.eu-S1031162AbXDZKo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031162AbXDZKo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031164AbXDZKo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:44:28 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:9867 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031162AbXDZKo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=flSFTAEWX0vxcS4fZ1xhWXuKKkJWfSFQixEPjMEXFt5ThNCsK6SvlqvzNvZ2wRNPVM5Mztdo6bllG6EMfFVo3bXTl3SSIYSF6OHxVRXcN1jNYYwZ7VxnIimwbzi87JE1UxtPUeRg9rsb43eDLQxmk3qh2UkcESQABnrQrB6yhtU=
Message-ID: <9a8748490704260344y72551a9w97609ca44f242019@mail.gmail.com>
Date: Thu, 26 Apr 2007 12:44:25 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: Linux 2.6.21
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070426040806.GJ3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
	 <20070426040806.GJ3468@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Wed, Apr 25, 2007 at 08:29:28PM -0700, Linus Torvalds wrote:
> >...
> > So it's been over two and a half months, and while it's certainly not the
> > longest release cycle ever, it still dragged out a bit longer than I'd
> > have hoped for and it should have. As usual, I'd like to thank Adrian (and
> > the people who jumped on the entries Adrian had) for keeping everybody on
> > their toes with the regression list - there's a few entries there still,
> > but it got to the point where we didn't even know if they were real
> > regressions, and delaying things further just wasn't going to help.
> >...
>
>
> Number of different known regressions compared to 2.6.20 at the time
> of the 2.6.21 release:
> 14
>
> Number of different known regressions compared to 2.6.20 at the time
> of the 2.6.21 release that were first reported in March or earlier:
> 8
>
> Number of different known regressions compared to 2.6.20 at the time
> of the 2.6.21 release with patches available at the time of the 2.6.21
> release [1]:
> 3
>
> What I will NOT do:
> Waste my time with tracking 2.6.22-rc regressions.
>
>
> We have an astonishing amount of -rc testers, but obviously not the
> developer manpower for handling them.
>
> If we would take "no regressions" seriously, it might take 4 or 5 months
> between releases due to the lack of developer manpower for handling
> regressions. But that should be considered OK if avoiding regressions
> was considered more important than getting as quick as possible to the
> next two week regression-merge window.
>
> But releasing with so many known regressions is insulting for the many
> people who spent their time testing -rc kernels.
>

Many people have already said this, but it needs saying again.
You are doing a great job that really helps, both with the regression
lists and the trivial patch monkey stuff. Please keep up the good
work, you are really helping the kernel.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
