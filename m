Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbXC2Mzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbXC2Mzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 08:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbXC2Mzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 08:55:51 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:28268 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbXC2Mzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 08:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Yq5gdGB3uGciMkcAe8xP9kfTg/j2SF6PzrVoHBvA4mgDNYAr9XYi9q6Op3b1TuzzfRxici/84rrEgYWV1iD2pthvywofT6Etiro/M1nqcfnIZcklEh8XzoJycZ8876fJBg8lTKivoszDN5E2/UtcSWmP7052GycGRk3Tfc9aKkk=
Message-ID: <b14e81f00703290555l11c78662y1733151878e4331a@mail.gmail.com>
Date: Thu, 29 Mar 2007 08:55:49 -0400
From: "michael chang" <thenewme91@gmail.com>
To: "Mike Galbraith" <efault@gmx.de>
Subject: Re: [ck] Re: [PATCH] sched: staircase deadline misc fixes
Cc: "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       "linux list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1175156283.6430.143.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703290237.38777.kernel@kolivas.org>
	 <20070328184843.GA17420@elte.hu>
	 <200703290944.45888.kernel@kolivas.org>
	 <1175147455.6430.91.camel@Homer.simpson.net>
	 <1175156283.6430.143.camel@Homer.simpson.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/07, Mike Galbraith <efault@gmx.de> wrote:
> Rereading to make sure I wasn't unclear anywhere...
>
> On Thu, 2007-03-29 at 07:50 +0200, Mike Galbraith wrote:
> >
> > I don't see what a < 95% load really means.
>
> Egad.  Here I'm pondering the numbers and light load as I'm typing, and
> my fingers (seemingly independent when mind wanders off) typed < 95% as
> in not fully committed, instead of "light".

While I don't know the _exact_ figure for this, my hunch is that a
good ballpark figure is anything that is not a heavy load (less than
4, perhaps even lower, maybe <0.75 or <2?) and that is not a "niced"
load.

-- 
-- Michael Chang
~Just the crazy copy cat~
