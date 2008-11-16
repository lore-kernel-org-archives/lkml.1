Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbYKPHtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbYKPHtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 02:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYKPHtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 02:49:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55943 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbYKPHtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 02:49:14 -0500
Date: Sun, 16 Nov 2008 08:48:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch 16/16]
	marker_synchronize_unregister->tracepoint_synchronize_unregister
Message-ID: <20081116074851.GA530@elte.hu>
References: <20081114224733.364965865@polymtl.ca> <20081114224949.751661181@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114224949.751661181@polymtl.ca>
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

> Impact: documentation update.
> 
> Signed-off-by: Zhaolei <zhaolei@cn.fujitsu.com>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Lai Jiangshan <laijs@cn.fujitsu.com>

This should have been:

From: Zhaolei <zhaolei@cn.fujitsu.com>

correct?

I updated the patch accordingly.

	Ingo
