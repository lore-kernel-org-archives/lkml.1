Return-Path: <linux-kernel-owner+w=401wt.eu-S1761089AbZDQNuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089AbZDQNuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761087AbZDQNug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:50:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32902 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760010AbZDQNue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:50:34 -0400
Date: Fri, 17 Apr 2009 15:49:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] x86/irq: remove NUMA_MIGRATE_IRQ_DESC
Message-ID: <20090417134934.GB23493@elte.hu>
References: <49E68C41.4020801@kernel.org> <20090416090315.GF9813@elte.hu> <49E802CE.5030406@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E802CE.5030406@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, this series looks very nice now.

Suresh, Eric, does it look good to you too? (please send Acks if so)

	Ingo
