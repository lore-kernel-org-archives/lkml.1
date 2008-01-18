Return-Path: <linux-kernel-owner+w=401wt.eu-S1762945AbYARQSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762945AbYARQSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762263AbYARQRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:17:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51872 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761983AbYARQRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:17:46 -0500
Date: Fri, 18 Jan 2008 17:17:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: [PATCH 2/2] Allow any x86 sub-architecture type to set
	CONFIG_NUMA
Message-ID: <20080118161731.GB5850@elte.hu>
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> <20080118153609.12646.97784.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118153609.12646.97784.sendpatchset@skynet.skynet.ie>
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


* Mel Gorman <mel@csn.ul.ie> wrote:

> While there are a limited number of x86 sub-architecture types that 
> can really support NUMA, there is nothing stopping other machines 
> booting that type of kernel. The fact that X86_GENERICARCH can set 
> NUMA currently is an indicator of that. This restriction only limits 
> potential testing coverage. This patch allows any sub-architecture to 
> set CONFIG_NUMA if they wish.

thanks, applied.

	Ingo
