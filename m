Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbXLSKSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbXLSKSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 05:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbXLSKS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 05:18:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36857 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbXLSKS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 05:18:29 -0500
Date: Wed, 19 Dec 2007 11:18:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] various scheduler patches
Message-ID: <20071219101820.GD3521@elte.hu>
References: <20071218174120.711901000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218174120.711901000@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> The first patch fixes a serious bug in RT task accounting and should 
> go in .24
> 
> The latter two add a RT watchdog rlimit that ensures RT tasks don't 
> unintentionally hog the cpu.

thanks, applied all of them - and queued up the first one for .24 
merging.

	Ingo
