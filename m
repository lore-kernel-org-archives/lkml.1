Return-Path: <linux-kernel-owner+w=401wt.eu-S966222AbXBPI3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966222AbXBPI3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 03:29:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966225AbXBPI3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 03:29:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48004 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966222AbXBPI3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 03:29:00 -0500
Date: Fri, 16 Feb 2007 09:25:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rui Nuno Capela <rncbc@rncbc.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rt5 Oops on boot [-rt8 OK]
Message-ID: <20070216082551.GA26948@elte.hu>
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org> <45CCC3CF.4090604@rncbc.org> <45D4FEFC.5070306@rncbc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D4FEFC.5070306@rncbc.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rui Nuno Capela <rncbc@rncbc.org> wrote:

> Rui Nuno Capela (me) wrote:
> > 
> > I have terrible news: 2.6.20-rt5 does not boot at all on a couple
> > machines I was brave enough to try -- a P4@3.3Ghz SMP/HT desktop, and a
> > Core2 Duo T7200@2.0Ghz laptop. For the first case I could capture the
> > following dump via serial console:
> > ...
> 
> News are that 2.6.20-rt8 got it all back to business :)

great! The fix is from Michal/Clark/Steve.

	Ingo
