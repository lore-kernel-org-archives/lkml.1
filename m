Return-Path: <linux-kernel-owner+w=401wt.eu-S1764859AbZAONhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764859AbZAONhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757562AbZAONhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:37:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41616 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756764AbZAONg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:36:59 -0500
Date: Thu, 15 Jan 2009 14:36:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
       ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       travis@sgi.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
Message-ID: <20090115133637.GA2468@elte.hu>
References: <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <496F0F50.6070200@kernel.org> <20090115113045.GG22850@elte.hu> <496F2032.5080502@kernel.org> <20090115122611.GJ22850@elte.hu> <496F346B.6020804@kernel.org> <20090115130740.GE21839@elte.hu> <496F38C7.5000403@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496F38C7.5000403@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Okay, here's the updated patch.  It's on top of x86/percpu[1].  You
> can pull from... (or just take the mail, I don't have much problem
> with rebasing, so whatever suits you better works for me).
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
> 
> [1] d5fd35177b763186a3f6288624094ee402f0a7e3

Pulled into tip/x86/percpu, thanks Tejun!

	Ingo
