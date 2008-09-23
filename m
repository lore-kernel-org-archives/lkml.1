Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYIWOSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYIWOSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbYIWOSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:18:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48740 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbYIWOSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:18:11 -0400
Date: Tue, 23 Sep 2008 16:18:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] lockstat: fixup signed division
Message-ID: <20080923141806.GB14041@elte.hu>
References: <20080923133340.929758093@programming.kicks-ass.net> <20080923133459.116940632@programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923133459.116940632@programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Some recent modification to this code made me notice the little todo mark.
> Now that we have more elaborate 64-bit division functions this isn't hard.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

applied to tip/core/locking, thanks Peter!

	Ingo
