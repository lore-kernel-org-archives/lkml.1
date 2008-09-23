Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbYIWLu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbYIWLu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbYIWLuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:50:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57262 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYIWLuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:50:51 -0400
Date: Tue, 23 Sep 2008 13:50:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Steigerwald <ms@teamix.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] CFS scheduler: documentation about scheduling policies
Message-ID: <20080923115045.GG14840@elte.hu>
References: <200809231101.41624.ms@teamix.de> <20080923091159.GE31189@elte.hu> <200809231348.50834.ms@teamix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809231348.50834.ms@teamix.de>
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


* Martin Steigerwald <ms@teamix.de> wrote:

> > please use -p1 to create patches - or since you've just set up the 
> > tip/master tracking, do something like:
> 
> Okay, lets see how this works out.
> 
> ---
> From a57581d4ec3b13f63920b89c336ac9c93c6cf9f0 Mon Sep 17 00:00:00 2001
> From: Martin Steigerwald <ms@teamix.de>
> Date: Tue, 23 Sep 2008 13:45:46 +0200
> Subject: [PATCH] CFS: Documentation about scheduling policies

Applied to tip/sched/devel, merged it into tip/master and pushed the 
result out - thanks Martin.

this was a perfect patch :)

	Ingo
