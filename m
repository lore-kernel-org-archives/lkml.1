Return-Path: <linux-kernel-owner+w=401wt.eu-S1765317AbZDAPHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765317AbZDAPHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762948AbZDAPHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:07:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36017 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198AbZDAPHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:07:30 -0400
Date: Wed, 1 Apr 2009 17:07:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH -tip 1/3] x86, mce: Add mce_threshold option for intel
	cmci
Message-ID: <20090401150711.GA20037@elte.hu>
References: <49CB3F24.8040804@jp.fujitsu.com> <20090328120825.GB14464@elte.hu> <49D183B0.6060306@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D183B0.6060306@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> Hi Ingo,
> 
> Sorry, could you drop patch 1/3 and 3/3 from your -tip tree? Andi 
> and I discussed some and agreed disabling CMCI need to be done in 
> different way (at least parameter name).

Could you please send a patch that changes the parameter name?

Thanks,

	Ingo
