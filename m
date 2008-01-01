Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbYAAO0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbYAAO0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 09:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYAAO0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 09:26:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60118 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbYAAO0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 09:26:42 -0500
Date: Tue, 1 Jan 2008 15:26:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Message-ID: <20080101142623.GA3592@elte.hu>
References: <20080101134809.GK2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101134809.GK2360@does.not.exist>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0009]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> This patch removes the EXPERIMENTAL option and all dependencies on 
> EXPERIMENTAL since they are pointless.

agreed. CONFIG_BROKEN has real use - but CONFIG_EXPERIMENTAL is pretty 
pointless in the 90-days kernel development model.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
