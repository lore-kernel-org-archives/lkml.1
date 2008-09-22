Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbYIVLCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbYIVLCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 07:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYIVLBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 07:01:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44330 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbYIVLBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 07:01:06 -0400
Date: Mon, 22 Sep 2008 13:00:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: trivial fix for incorrect comments
Message-ID: <20080922110049.GA5987@elte.hu>
References: <48D3C9FF.20504@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D3C9FF.20504@nortel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2181]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Friesen <cfriesen@nortel.com> wrote:

> From: Chris Friesen    <cfriesen@nortel.com>
>
> A couple of the comments for the conditional definitions in sched.c are
> incorrect.  Here's a trivial patch fixing them up.

looks good to me, but the patch is whitespace corrupted. Please see 
Documentation/email-clients.txt about how to send plain-text patches.

	Ingo
