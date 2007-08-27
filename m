Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbXH0PMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbXH0PMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbXH0PMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:12:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:46578 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbXH0PL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TeKbulGtCP2YFzc/l69EbL2y1LNSwU9WObaYvml/+xcMwy7cuJywrRxYIK5Y55lOiJcaeIjRkowx94mJhVL4w17Vo2G8qupOhAONQqXePNoyI8eknvID8x53Aa/2ZCnMqs2WyG5VJRPs1mYyoJHRE6RubP6YrFoM3Qk1QoKxp4Q=
Message-ID: <6bffcb0e0708270811t645e5794pdd76596f71f1ba7e@mail.gmail.com>
Date: Mon, 27 Aug 2007 17:11:55 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: Who wants to maintain KR list for stable releases? (was Re: nmi_watchdog=2 regression in 2.6.21)
Cc: "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <1188225567.2435.188.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186531609.22044.50.camel@imap.mvista.com>
	 <20070808142059.GF30805@atjola.homenet>
	 <1187628296.7732.14.camel@imap.mvista.com>
	 <46CDE94A.7000600@googlemail.com>
	 <1187904169.2435.83.camel@dhcp193.mvista.com>
	 <46D21E8E.4000003@googlemail.com>
	 <1188225567.2435.188.camel@dhcp193.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/07, Daniel Walker <dwalker@mvista.com> wrote:
> On Mon, 2007-08-27 at 02:45 +0200, Michal Piotrowski wrote:
> > Daniel Walker pisze:
> > [snip]
> > > Have you considered maintaining all the lists in Bugzilla?
> >
> > Yes, I have considered it.
> >
> > Bugzilla sucks when it comes to tracking things. There is
> > a regression field, but there are no difference between
> > 2.6.22 and 2.6.23 regression.
> >
> > Most people are reporting bugs through LKML:
> > - 23 regressions with reference to LKML
> > - 4 regressions with reference to Bugzilla
>
> The main reason that I commented on this was because of your comment
> below in the release emails,
>
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
>
> And I was thinking, if these bugz need to transition over the bugzilla
> anyway why not go straight there instead of via kernelnewbies .. People
> would just get bugzilla accounts and open new bugz entry.

Some people hates Bugzilla, and they do not want to use it.

>
> I not trying to force you into something , and ultimately it whatever is
> easier for you.. Which was my main reason for commenting on it.
>
> > > If you had a
> > > search of open bugs they would just fall of the list as they get
> > > closed..
> >
> > Unfortunately, the world is not perfect.
>
> I think over time it would work like that , but I'm sure there's lots of
> people who don't care about our bugzilla ..
>
> Daniel
>
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
