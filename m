Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbXLLJ5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbXLLJ5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 04:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbXLLJ53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 04:57:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40791 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbXLLJ52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 04:57:28 -0500
Date: Wed, 12 Dec 2007 10:57:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [crash] kernel BUG at drivers/cpufreq/cpufreq.c:1060!
Message-ID: <20071212095702.GA16560@elte.hu>
References: <20071212091144.GA11986@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212091144.GA11986@elte.hu>
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

> 2.6.24-rc4-git5, got this cpufreq crash on x86 64-bit, during 'make 
> randconfig' random bootup testing:

hm, does not seem to be easily reproducible. I tried 10 bootups and 2 of 
them failed.

	Ingo
