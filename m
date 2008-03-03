Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbYCCIZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbYCCIZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 03:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYCCIZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 03:25:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60492 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbYCCIZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 03:25:19 -0500
Date: Mon, 3 Mar 2008 09:24:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] proper extern for late_time_init
Message-ID: <20080303082454.GC13580@elte.hu>
References: <20080301161845.GL25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301161845.GL25835@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> This patch adds a proper extern for late_time_init in 
> include/linux/init.h

Acked-by: Ingo Molnar <mingo@elte.hu>

should go via -mm i think.

	Ingo
