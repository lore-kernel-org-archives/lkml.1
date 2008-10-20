Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbYJTNbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbYJTNbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 09:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYJTNbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 09:31:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59964 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbYJTNbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 09:31:34 -0400
Date: Mon, 20 Oct 2008 15:31:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip/tracing/markers] markers: let marker_table be close
	to its comments
Message-ID: <20081020133113.GC27656@elte.hu>
References: <48F5942F.4080400@cn.fujitsu.com> <20081015134446.GB29281@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015134446.GB29281@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0115]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> > 
> > marker_table is defined far from its comments, this fix make
> > cleanup for it.
> > 
> 
> Good idea! Thanks.
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

applied to tip/tracing/markers, thanks!

	Ingo
