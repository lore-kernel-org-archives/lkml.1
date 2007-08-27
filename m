Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbXH0Lij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbXH0Lij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 07:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbXH0Lic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 07:38:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:51623 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbXH0Lib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 07:38:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JeiGsjbhDl5caHN9OqgZjKZdADp94OZRUl+hskW07aXv0ZExRb/8zs5w8BiGwZPoXlr+G3XcFPAgP9K2FSOTLo1EL/t6Enw0kpKYDu9+6cW3WjJGqIWIJqwoRarsIPtBNwVsEHoDfSNurrvmGYA+P+ZF7P4Pb5Cd/ptz1Wx2M7E=
Message-ID: <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com>
Date: Mon, 27 Aug 2007 13:38:30 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Who wants to maintain KR list for stable releases? (was Re: nmi_watchdog=2 regression in 2.6.21)
Cc: "Daniel Walker" <dwalker@mvista.com>,
       "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <20070827005131.b93f5935.akpm@linux-foundation.org>
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
	 <20070827005131.b93f5935.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 27 Aug 2007 02:45:02 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
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
> Presumably that's fixable.
>
> But I think bugzilla is more appropriate for tracking longer-term bugs.  If
> some problem has just popped up (or has just been discovered) then it's
> best to try to knock it over with a quick email discussion.  If that
> doesn't work out then the bug should be captured in bugzilla so that it
> doesn't get lost.
>
> The really important data which bugzilla will record are
>
> a) the fact that the bug exists and
>
> b) the identity of the person who can reproduce it and who will hopefully
> work with us on fixing it.
>
> > > If you had a
> > > search of open bugs they would just fall of the list as they get
> > > closed..
> >
> > Unfortunately, the world is not perfect.
> >
> > Is anyone interested in maintaining KR list for stable releases?
>
> I'm not sure that we need one, really.  Any bugs in a stable release can be
> handled via email and/or bugzilla as we are presently doing?
>
> What I'm concerned about is that regressions which we didn't fix are just
> getting lost.  Is anyone taking care to ensure that they are getting
> transitioned into bugzilla for tracking?

I can copy all regression reports into Bugzilla after each release.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
