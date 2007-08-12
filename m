Return-Path: <linux-kernel-owner+w=401wt.eu-S934360AbXHLKhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934360AbXHLKhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 06:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbXHLKg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 06:36:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58671 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbXHLKgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 06:36:55 -0400
Date: Sun, 12 Aug 2007 12:36:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] run_rebalance_domains: s/SCHED_IDLE/CPU_IDLE/
Message-ID: <20070812103647.GB15297@elte.hu>
References: <20070812102357.GA525@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812102357.GA525@tv-sign.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.6
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.6 required=5.9 tests=BAYES_00,UPPERCASE_25_50 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.4 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> rebalance_domains(SCHED_IDLE) looks strange (typo?), change it to 
> CPU_IDLE.

indeed! Sharp eyes :) I've applied your patch.

	Ingo
