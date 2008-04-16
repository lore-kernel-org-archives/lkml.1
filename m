Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbYDPAvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbYDPAvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYDPAuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:50:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35375 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbYDPAuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:50:51 -0400
Date: Wed, 16 Apr 2008 02:50:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Soeren Sonnenburg <kernel@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Lord <lkml@rtr.ca>
Subject: Re: [Bug #10117] 2.6.25-current-git sometimes hangs on boot
	-dual-core Sony Vaio
Message-ID: <20080416005036.GA26996@elte.hu>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <200804152233.39079.rjw@sisk.pl> <20080415204500.GD1677@cs181133002.pp.htv.fi> <200804152303.45320.rjw@sisk.pl> <924EFEDD5F540B4284297C4DC59F3DEEE17FD4@orsmsx423.amr.corp.intel.com> <1208294294.7851.109.camel@localhost> <924EFEDD5F540B4284297C4DC59F3DEEE17FF1@orsmsx423.amr.corp.intel.com> <20080415212949.GG1677@cs181133002.pp.htv.fi> <20080415225411.GA10041@localhost.ift.unesp.br> <20080416001925.GM1677@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416001925.GM1677@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> On Tue, Apr 15, 2008 at 07:54:11PM -0300, Carlos R. Mafra wrote:
> > On Wed 16.Apr'08 at  0:29:49 +0300, Adrian Bunk wrote:
> >...
> > > We must learn to more aggressively point people at reporting their 
> > > issues in own bugs, instead of hijacking an already existing similar
> > > looking bug (that might be for a different issue).
> > 
> > I understand now, but you made me feel bad about it.
> 
> Sorry for my wording, it was not meant personally.
> 
> It's a general problem in bug trackers that one person reports one 
> issue, and other people say "I have the same bug" and start discussing 
> their problem, which might or might not turn out to be the same.

... which you should realize that this is generally a _GOOD_ thing. This 
whole Linux thing is about doing things in a group, not about doing 
things separately. It permeates everything and it's our main strength.

Analogously to nuclear fission and to torrent streams, bug handling 
needs a "critical mass" as well - the more testers, the better. (even if 
they end up having different issues)

So i'd rather see bugs being mistakenly handled together (they are easy 
to separate out once they are established to be separate) than the same 
bug being processed on two different tracks.

Your rigid, buerocratic view of this matter is wrong, harmful and it 
actively discourages testers. Please stop it.

	Ingo
