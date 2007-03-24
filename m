Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbXCXQNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbXCXQNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 12:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbXCXQNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 12:13:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:30168 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbXCXQNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 12:13:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iVQcsTimLFrfoiKDhxAE2UlHJB/HyBsW1LQFH0/nrDFuLKSQM5hccEzH/F5rhvfNk8iO6ud86G4D7kwTSD176/LroatvtcaicBCTnth4wT/VO2T+DwAEiEWXhUA7vqbx0IXEAoMvIHPASDkrVO8WC5pvNYxEwNcOlCoGg0ucxs0=
Message-ID: <6bffcb0e0703240913u59840654ua5f651370f3a6ae1@mail.gmail.com>
Date: Sat, 24 Mar 2007 17:13:30 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: tglx@linutronix.de
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1174749266.10840.430.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
	 <1174680500.10840.346.camel@localhost.localdomain>
	 <6bffcb0e0703240659r2e5a5875i746ccbbd28d0045c@mail.gmail.com>
	 <1174749266.10840.430.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/03/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sat, 2007-03-24 at 14:59 +0100, Michal Piotrowski wrote:
> > On 23/03/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > On Fri, 2007-03-23 at 19:50 +0100, Adrian Bunk wrote:
> > > > Subject    : soft lockup detected on CPU#0
> > > > References : http://lkml.org/lkml/2007/3/3/152
> > > > Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> > > > Handled-By : Thomas Gleixner <tglx@linutronix.de>
> > > >              Ingo Molnar <mingo@elte.hu>
> > > > Status     : unknown
> > >
> > > Michal,
> > >
> > > any news on that one ?
> > >
> > > You said the same problem exists in 2.6.20.1. Has this been resolved in
> > > 2.6.20.2/3
> >
> > Yes, I tried 2.6.20.4 and it works fine.
>
> Is it solved in Linus latest too ?

Yes, it's solved.

Adrian, please remove this bug from known regressions list.
It's fixed in the latest -git and -stable.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
