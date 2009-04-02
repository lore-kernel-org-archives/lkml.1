Return-Path: <linux-kernel-owner+w=401wt.eu-S1761201AbZDBSlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761201AbZDBSlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbZDBSlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:41:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34082 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbZDBSla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:41:30 -0400
Date: Thu, 2 Apr 2009 20:40:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: markus.t.metzger@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: tglx@linutronix.de, hpa@zytor.com, markus.t.metzger@gmail.com,
       roland@redhat.com, eranian@googlemail.com, oleg@redhat.com,
       juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 03/18] x86, ptrace, bts: defer branch trace stopping
Message-ID: <20090402184043.GB843@elte.hu>
References: <20090402145455.597376000@intel.com> <20090402145707.003976000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402145707.003976000@intel.com>
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


* markus.t.metzger@intel.com <markus.t.metzger@intel.com> wrote:

>  include/linux/mm.h       |    3 	2 +	1 -	0 !
>  mm/mlock.c               |   13 	6 +	7 -	0 !

the mm bits look good to me but need an Ack from akpm, peterz or 
other MM developers.

	Ingo
