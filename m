Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031498Ab0B1IKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 03:10:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59937 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031462Ab0B1IKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 03:10:00 -0500
Date: Sun, 28 Feb 2010 09:09:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       garyhade@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com, iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com,
       trenn@suse.de
Subject: Re: [PATCH -v11] x86: fix out of order of gsi -- partial
Message-ID: <20100228080941.GD14205@elte.hu>
References: <4B882182.4030205@kernel.org>
 <tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org>
 <20100227130113.GA18661@elte.hu>
 <m1y6ieo5zw.fsf@fess.ebiederm.org>
 <4B897537.5050406@kernel.org>
 <m1zl2ue585.fsf@fess.ebiederm.org>
 <4B8995FB.9000908@kernel.org>
 <m1mxyue31g.fsf@fess.ebiederm.org>
 <4B89E751.1060903@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B89E751.1060903@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> found IBM x3950 will have problem after
> 
> |commit b9c61b70075c87a8612624736faf4a2de5b1ed30

Have you seen the commit notifications i sent for the v8 patches:

Commit-ID:  ca8c764cb39bf6cade71933b38e8c830eb8b73c6
Commit-ID:  519d637a93116ffbcd50e9e3f2591f41584f372c

Those include a much improved changelogs - please adopt those. (and preferably 
send deltas against tip:tmp.x86/apic.)

Thanks,

	Ingo
