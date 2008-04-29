Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbYD2L0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbYD2L0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYD2L0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:26:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49618 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbYD2L0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:26:41 -0400
Date: Tue, 29 Apr 2008 13:26:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: mtrr cleanup for converting continuous to
	discrete layout v7
Message-ID: <20080429112624.GA22977@elte.hu>
References: <200804272337.40130.yhlu.kernel@gmail.com> <200804281316.14168.yhlu.kernel@gmail.com> <200804281505.05764.yhlu.kernel@gmail.com> <200804290200.33459.yhlu.kernel@gmail.com> <4816EEA1.6050804@googlemail.com> <86802c440804290330wd582daetb2a9c41a69f6e028@mail.gmail.com> <86802c440804290356l678d3a0cxedcbe21a1f7642d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804290356l678d3a0cxedcbe21a1f7642d1@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> >  will send you v8, and hope it will be last version.
> 
> please try v8, it should get rid of the 8m entry. it need patch 
> http://lkml.org/lkml/2008/4/29/97 too.

thanks, applied both of them, in the right order and pushed out the 
tree.

	Ingo
