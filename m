Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbYJTNbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbYJTNbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 09:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYJTNay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 09:30:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60918 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbYJTNax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 09:30:53 -0400
Date: Mon, 20 Oct 2008 15:30:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip/tracing/markers] markers: remove exported symbol
	marker_probe_cb_noarg()
Message-ID: <20081020133042.GB27656@elte.hu>
References: <48F5942A.2060705@cn.fujitsu.com> <20081015134519.GC29281@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015134519.GC29281@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> > 
> > marker_probe_cb_noarg() should not be seen by outer code.
> > this patch remove it.
> > 
> 
> Yep, good idea. Thanks!
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

applied to tip/tracing/markers, thanks!

	Ingo
