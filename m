Return-Path: <linux-kernel-owner+w=401wt.eu-S1765729AbYCFLBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765729AbYCFLBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764038AbYCFK43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:56:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40221 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760468AbYCFK4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:56:25 -0500
Date: Thu, 6 Mar 2008 11:56:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephan Diestelhorst <langer_mann@web.de>
Cc: davej@codemonkey.org.uk, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Speedfreq-SMI call clobbers ECX
Message-ID: <20080306105603.GL13391@elte.hu>
References: <200803051559.09962.langer_mann@web.de> <20080305153520.GB19300@elte.hu> <200803060938.20944.langer_mann@web.de> <200803060951.12002.langer_mann@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803060951.12002.langer_mann@web.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0031]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephan Diestelhorst <langer_mann@web.de> wrote:

> Again, should I provide these patches? This thing just annoyed me for 
> a while as I have been patching it in my personal kernels for too 
> long.

yes, please do keep sending them (and any other patches you might have) 
- it's a real issue on real hardware so we want this fix upstream.

	Ingo
