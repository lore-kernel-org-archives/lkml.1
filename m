Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYJWOW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYJWOW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbYJWOWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:22:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51457 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104AbYJWOWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:22:06 -0400
Date: Thu, 23 Oct 2008 16:21:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug #2] Re: [PATCH 00/35] cpumask: Replace cpumask_t with
	struct cpumask
Message-ID: <20081023142136.GA21964@elte.hu>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023120322.GC25132@elte.hu> <20081023125529.GA18327@elte.hu> <20081023142025.GA18804@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023142025.GA18804@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2501]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


here's the full result:

--------------->
Run 140: 2008-10-23 15:52:45 .. 2008-10-23 16:19:09

Run 140: 11 of 19 operations OK
Run 140: 8 of 19 operations FAILED

http://www.tglx.de/autoqa-logs/000140-0008-0005.log
http://www.tglx.de/autoqa-logs/000140-0008-0006.log
http://www.tglx.de/autoqa-logs/000140-0008-0025.log
http://www.tglx.de/autoqa-logs/000140-0008-0013.log
http://www.tglx.de/autoqa-logs/000140-0008-0014.log
http://www.tglx.de/autoqa-logs/000140-0008-0015.log
http://www.tglx.de/autoqa-logs/000140-0008-0020.log
http://www.tglx.de/autoqa-logs/000140-0008-0022.log

Full results at: http://www.tglx.de/autoqa/index
