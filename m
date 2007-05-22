Return-Path: <linux-kernel-owner+w=401wt.eu-S966040AbXEVRrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966040AbXEVRrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbXEVRrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:47:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:3801 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758169AbXEVRrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:47:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cAm5GXJ+HjQuBqCBmpbhvuvUiYCnhrk4LpqVG/QA8gs0xeoTSxZhtbiUEckTWbAHj2zbjctagasMYlR1zwTAGiKed8P+Fk8ivjG7yzOXeJ9ftma6dKpZOn44N26pEinSL1KAaD3scDjMq+j+r7X+MB97u94t3NE45D2MwL/ym7s=
Message-ID: <a781481a0705221046p6d94a652k3081eacdba01ca8d@mail.gmail.com>
Date: Tue, 22 May 2007 23:16:59 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Simon Horman" <horms@verge.net.au>, "Adrian Bunk" <bunk@stusta.de>,
       "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <46532AA4.6080501@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <46503542.50300@s5r6.in-berlin.de>
	 <a781481a0705200457v70aae469n97be31fe55af4d91@mail.gmail.com>
	 <46504876.9040802@s5r6.in-berlin.de>
	 <a781481a0705200650v2ef7be85h19f8c8eb026a303b@mail.gmail.com>
	 <46505DBD.5010005@s5r6.in-berlin.de>
	 <a781481a0705220753g25bb0dd8u33bbf8ddaf00f50c@mail.gmail.com>
	 <46532247.6030803@s5r6.in-berlin.de>
	 <a781481a0705221013m45f82054tca9a9a78ea8935d4@mail.gmail.com>
	 <46532AA4.6080501@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Satyam Sharma wrote:
> > On 5/22/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> >> > On 5/20/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> >> >>         depends on !PLATFORM_X || HELPER_N_ON_PLATFORM_X
> ...
> >> This is a synthetic example which might not have a real-world application.]
> >
> > Well, it is not relevant / equivalent to any of the four symbols that caused the
> > warnings that this thread is about, at least.
>
> (Have I ever said that this concrete expression can be used in whatever
> fix?)
>
> ...
> > and as I said, this was totally *not* the problem being discussed /
> > solved in this thread (and by that patch).
>
> My point was not about that particular expression. My point was:
>
>         I'm not advocating any specific fixes or pseudo-fixes.
>         I'm advocating the notation of dependencies in the direction
>         "A requires B".
>
> When I said "The standard and maintainable way (for drivers at least)
> is..." I didn't mean the example expression, I meant the *direction* in
> which the example was stating dependencies.

In that case I wish "the points" you make on threads are relevant to them.
