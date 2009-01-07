Return-Path: <linux-kernel-owner+w=401wt.eu-S1762260AbZAGWSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762260AbZAGWSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759712AbZAGWSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:18:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36934 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758883AbZAGWSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:18:40 -0500
Date: Wed, 7 Jan 2009 23:18:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Raja R Harinath <harinath@hurrynot.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH for -tip 4/4] irq: for_each_irq_desc() makes simplify
Message-ID: <20090107221830.GG17917@elte.hu>
References: <87wsdezyu6.fsf@hariville.hurrynot.org> <2f11576a0901012156w30a6b162v96aed31d357929e6@mail.gmail.com> <20090104030849.069A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104030849.069A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Ingo, could you please apply this patch to -tip tree?
> 
> 
> ===
> From 6f1210e6912afd8ca07518e82f89ba92137302b2 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Sun, 4 Jan 2009 02:37:26 +0900
> Subject: [PATCH] sparseirq: fix for_each_irq_desc() nit

applied to tip/irq/urgent, thanks!

	Ingo
