Return-Path: <linux-kernel-owner+w=401wt.eu-S1764236AbXHXVL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764236AbXHXVL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbXHXVLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:11:49 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:62868 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbXHXVLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:11:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p0ql0RP1UUkrNQM4C5t6DlVcJodHX1MLoNV0TZ4SjlLDis+SSBl4pLaZmO/oeUb1+yOQtQNid4rHc9cpAYM/J5GRhBlfuA4lTpGJTV2QrK/Pt97Oa21GB+0d2wL1N2dW0M9Hzek2+a9icvq/SGJU4DMAUKlkVUVsXa+9nuTP1Gc=
Message-ID: <8bd0f97a0708241411n50725f94y9cf1c27a58634319@mail.gmail.com>
Date: Fri, 24 Aug 2007 17:11:47 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [PATCH take #2] MAINTAINTERS: use our mail list as Blackfin arch maintainters.
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Bryan Wu" <bryan.wu@analog.com>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>, joe@perches.com,
       yi.li@analog.com, vivi.li@analog.com, torvalds@linux-foundation.org,
       sonic.zhang@analog.com, roy.huang@analog.com, robin.getz@analog.com,
       michael.hennerich@analog.com, michael.frysinger@analog.com,
       marc.hoffman@analog.com, linux-kernel@vger.kernel.org,
       jie.zhang@analog.com, grace.pan@analog.com, bernd.schmidt@analog.com,
       akpm@linux-foundation.org
In-Reply-To: <20070824161451.GM21720@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bff904.ANPWrqncsP8VpmBH%joe@perches.com>
	 <1187777706.24914.2.camel@roc-desktop>
	 <6bffcb0e0708220323w5592df25n9c21c7e3aca1dbfb@mail.gmail.com>
	 <8bd0f97a0708220345g26c35288g5e96b6f1f8491f0e@mail.gmail.com>
	 <1187794511.6805.3.camel@roc-laptop>
	 <20070824002413.GB20266@waste.org>
	 <1187928287.5949.2.camel@roc-desktop>
	 <20070824045635.GK21720@waste.org>
	 <20070824100943.4e81932a@the-village.bc.nu>
	 <20070824161451.GM21720@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/07, Matt Mackall <mpm@selenic.com> wrote:
> My observation is actually from the other side, Alan. I run a list
> that used to send exactly such messages and got complaints from people
> in this community about running a subscribers-only list. My natural
> conclusion was that the messages were considered to be a problem.
> Given that the moderation messages from Mailman actually mention
> "subscribers-only", I can't blame non-subscribers for feeling
> thwarted, frustrated, annoyed, or inconvenienced when they receive it.

there's a difference between getting a response that says it's being
held pending a moderator approving it and a response that says it's
been flat out rejected until you subscribe

> Since I was already whitelisting legitimate posters, I simply turned
> off the moderation messages back to the poster. Now the fact that the
> list is moderated is completely transparent and no one gets any rude
> automated messages.

that's easy enough to do
-mike
