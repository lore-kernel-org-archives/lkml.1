Return-Path: <linux-kernel-owner+w=401wt.eu-S965577AbYD1RcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965577AbYD1RcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934620AbYD1Rbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:31:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45736 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934304AbYD1Rbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:31:34 -0400
Date: Mon, 28 Apr 2008 19:31:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2] use canary at end of stack to indicate overruns at
	oops time
Message-ID: <20080428173112.GE23620@elte.hu>
References: <480D5F27.1030101@redhat.com> <480E5ACF.7010105@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480E5ACF.7010105@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0311]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Sandeen <sandeen@sandeen.net> wrote:

> (Updated with a common max-stack-used checker that knows about the 
> canary, as suggested by Joe Perches)

thanks - picked up this updated version.

	Ingo
