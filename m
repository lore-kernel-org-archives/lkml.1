Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYBWQo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYBWQo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 11:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYBWQou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 11:44:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46457 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbYBWQot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 11:44:49 -0500
Date: Sat, 23 Feb 2008 17:44:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Alexey Zaytsev <zaytsev.a@protei.ru>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Message-ID: <20080223164433.GA7744@elte.hu>
References: <47BEAF3B.3080809@protei.ru> <200802221848.37902.mb@bu3sch.de> <20080223110751.GN23833@elte.hu> <200802231727.54351.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802231727.54351.mb@bu3sch.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Buesch <mb@bu3sch.de> wrote:

> On Saturday 23 February 2008 12:07:51 Ingo Molnar wrote:
> > I have to say, after having observed multiple incidents around b43 in 
> > the past few months you are one of the worst driver maintainers i've 
> > ever seen on lkml: you are ignoring regressions, you are frequently 
> > insulting our testers and now you even have the gall to NAK a patch to 
> 
> The insults being? A few quotes, please.

  " I'm tired of this "how dare can you break my kernel!?" bullshit. "
  ...
  " Blah. The people with a bcm4311 revision 1 wireless card plus a 
    bcm44xx ethernet card. You can count those people on two fingers. "
  ...

    http://lkml.org/lkml/2008/2/23/3

	Ingo
