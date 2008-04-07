Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbYDGSs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbYDGSs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYDGSsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:48:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33949 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbYDGSsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:48:20 -0400
Date: Mon, 7 Apr 2008 20:47:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: print out buggy mptable
Message-ID: <20080407184758.GA12292@elte.hu>
References: <200804071136.40000.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804071136.40000.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3706]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> print out buggy mptable, instead of skipping it quietly

thanks Yinghai, applied.

	Ingo
