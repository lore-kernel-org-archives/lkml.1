Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYC0JC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYC0JC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYC0JCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:02:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55973 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbYC0JCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:02:18 -0400
Date: Thu, 27 Mar 2008 10:01:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] generic: simplify setup_nr_cpu_ids and add
	set_cpus_allowed_ptr
Message-ID: <20080327090155.GB30918@elte.hu>
References: <20080326212347.466221000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326212347.466221000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3402]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Two simple patches to simplify setup_nr_cpu_ids and add a new 
> function, set_cpus_allowed_ptr().

thanks, applied to the scheduler queue.

	Ingo
