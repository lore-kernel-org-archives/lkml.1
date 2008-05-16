Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbYEPNEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbYEPNEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbYEPNDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:03:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52274 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbYEPNDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:03:54 -0400
Date: Fri, 16 May 2008 15:03:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] x86: Move es7000_plat out of mpparse.c
Message-ID: <20080516130342.GA22993@elte.hu>
References: <20080514150251.24443.5516.stgit@thinkpad> <20080516124319.GB16520@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516124319.GB16520@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> applied, thanks Alexey.

btw., this VISWS config still fails to build on latest -tip, and i think 
it's due to your earlier changes:

  http://redhat.com/~mingo/misc/config-Fri_May_16_14_50_15_CEST_2008.bad

you can pick up -tip via:

  http://people.redhat.com/mingo/tip.git/README

check out the auto-latest branch.

	Ingo
