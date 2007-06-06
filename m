Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbXFFHci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbXFFHci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXFFHca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:32:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40880 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbXFFHc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:32:29 -0400
Date: Wed, 6 Jun 2007 09:32:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] fs/proc/base.c: make a struct static
Message-ID: <20070606073220.GA13088@elte.hu>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070605215106.GL5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605215106.GL5500@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@stusta.de> wrote:

> This patch makes the needlessly global struct proc_pid_sched_operations 
> static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

thanks.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
