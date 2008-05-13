Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbYEMMcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbYEMMcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbYEMMco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:32:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33799 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbYEMMcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:32:43 -0400
Date: Tue, 13 May 2008 14:32:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: lizf@cn.fujitsu.com, akpm@linux-foundation.org,
       seto.hidetoshi@jp.fujitsu.com, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: limit the input of
	cpuset.sched_relax_domain_level
Message-ID: <20080513123222.GD14973@elte.hu>
References: <4828FC85.7020400@cn.fujitsu.com> <20080512214021.8ca3553e.pj@sgi.com> <20080512214319.5f0754e8.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512214319.5f0754e8.pj@sgi.com>
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


* Paul Jackson <pj@sgi.com> wrote:

> Acked-by: Paul Jackson <pj@sgi.com>

applied, thanks.

	Ingo
