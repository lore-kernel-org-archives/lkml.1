Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYHRIm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYHRIm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 04:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYHRImu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 04:42:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51611 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbYHRImt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 04:42:49 -0400
Date: Mon, 18 Aug 2008 10:42:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: fix incorrect comment style of
	__ftrace_enabled_save()
Message-ID: <20080818084232.GA28563@elte.hu>
References: <1219047896.5663.57.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219047896.5663.57.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang Ying <ying.huang@intel.com> wrote:

> This patch fixes incorrect comment style of __ftrace_enabled_save().
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

applied to tip/tracing/ftrace - thanks!

	Ingo
