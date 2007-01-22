Return-Path: <linux-kernel-owner+w=401wt.eu-S932464AbXAVUAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbXAVUAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932157AbXAVUAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:00:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46029 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932471AbXAVUA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:00:28 -0500
Date: Mon, 22 Jan 2007 20:58:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Noah Watkins <nwatkins@ittc.ku.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] whitespace cleanup for 2.6.20-rc5-rt7
Message-ID: <20070122195836.GC21277@elte.hu>
References: <11693256381932-git-send-email-nwatkins@ittc.ku.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11693256381932-git-send-email-nwatkins@ittc.ku.edu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0025]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Noah Watkins <nwatkins@ittc.ku.edu> wrote:

> fixes trailing whitespace and spaces before tab indents in 
> 2.6.20-rc5-rt7 as reported with: git-apply --whitespace=error-all

thanks. Did you do the patch manually, or do you have a script for that 
perhaps?

	Ingo
