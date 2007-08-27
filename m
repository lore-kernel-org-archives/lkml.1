Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbXH0P03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbXH0P03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbXH0P0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:26:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:32973 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbXH0P0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:26:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VADq1IoneBZdBK8aXQN1Ux59Nf+sd8qZ7Qxjth58Tccp4wsCZAVr/pha5iwZvNPtt/kUKd9CP2G3v+s/W+h2QcDG+6PBPpByegyU9151rmqGFvb4NeJCsTk8ayI9YsHHsNg/Blm5zKWx/jmabi+yDRyhXcCMhYOdjYwP81zsZ4k=
Message-ID: <6bffcb0e0708270826p7a7fb044re53d0db4094bc3d5@mail.gmail.com>
Date: Mon, 27 Aug 2007 17:26:19 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: Who wants to maintain KR list for stable releases? (was Re: nmi_watchdog=2 regression in 2.6.21)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <1188227585.2435.192.camel@dhcp193.mvista.com>
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
	 <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com>
	 <1188227585.2435.192.camel@dhcp193.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/07, Daniel Walker <dwalker@mvista.com> wrote:
> On Mon, 2007-08-27 at 13:38 +0200, Michal Piotrowski wrote:
> > On 27/08/07, Andrew Morton <akpm@linux-foundation.org> wrote:
[..]
> > > I'm not sure that we need one, really.  Any bugs in a stable release can be
> > > handled via email and/or bugzilla as we are presently doing?
> > >
> > > What I'm concerned about is that regressions which we didn't fix are just
> > > getting lost.  Is anyone taking care to ensure that they are getting
> > > transitioned into bugzilla for tracking?
> >
> > I can copy all regression reports into Bugzilla after each release.
>
> Should we get the regression field fix before? Or had you planned on
> just bypassing that completely ?

IMO solution proposed by David http://lkml.org/lkml/2007/8/27/21 seems
to be most reasonable.

>
> Daniel
>
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
