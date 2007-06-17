Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbXFQQrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbXFQQrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 12:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbXFQQrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 12:47:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:14645 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbXFQQrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 12:47:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FiJzUyCac5S1mDgjqvmCDhDFBls1MseTCNri9NoNNWRRo0OK8ER5tWFV+FR3FxijUHDiNhRxnqiEKAY+Obp+jDwZ3TGDUMAAg7/oeeAB4yR43DYXaXUvhRWQGsG7G7ApGh0V3gD1ZmFhO70G7XSJ8Mx6WsFWXOpgYFfzJ0F+36M=
Message-ID: <6bffcb0e0706170947g33dfe98co47ca0eeccce851c4@mail.gmail.com>
Date: Sun, 17 Jun 2007 18:47:10 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: How to improve the quality of the kernel?
Cc: "Adrian Bunk" <bunk@stusta.de>, "Oleg Verych" <olecom@flower.upol.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Diego Calleja" <diegocg@gmail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <467560CF.6090100@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
	 <20070615234202.GP3588@stusta.de>
	 <20070616013236.GA16016@flower.upol.cz>
	 <4673D63D.5020804@s5r6.in-berlin.de> <20070617004436.GU3588@stusta.de>
	 <467501D0.3090203@googlemail.com> <20070617124508.GV3588@stusta.de>
	 <6bffcb0e0706170617k32e79d96q5af1bcd7d9492cb8@mail.gmail.com>
	 <20070617142950.GW3588@stusta.de> <467560CF.6090100@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/06/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Adrian Bunk wrote:
> >>> And we should be aware that reverting is only a workaround for the real
> >>> problem which lies in our bug handling.
> >> ...
> >
> > And this is something I want to emphasize again.
> >
> > How can we make any progress with the real problem and not only the
> > symptoms?
> ...
>
> Perhaps make lists of
>
>   - bug reports which never lead to any debug activity
>     (no responsible person/team was found, or a seemingly person/team
>     did not start to debug the report)
>
>   - known regressions on release,
>
>   - regressions that became known after release,
>
>   - subsystems with notable backlogs of old bugs,
>
>   - other categories?

It is unworkable in wiki.

There is a new regression field in bugzilla, but it is only the first
step to implement regression tracking feature.

>
> Select typical cases from each categories, analyze what went wrong in
> these cases, and try to identify practicable countermeasures.
>
> Another approach:  Figure out areas where quality is exemplary and try
> to draw conclusions for areas where quality is lacking.
> --
> Stefan Richter
> -=====-=-=== -==- =---=
> http://arcgraph.de/sr/
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
