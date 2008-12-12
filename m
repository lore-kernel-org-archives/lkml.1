Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYLLJBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYLLJBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758568AbYLLJBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:01:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60764 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758557AbYLLJBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:01:20 -0500
Date: Fri, 12 Dec 2008 10:01:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/fastboot: include missing headers
Message-ID: <20081212090116.GE25106@elte.hu>
References: <49412E4F.9080307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49412E4F.9080307@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> For now include/trace/boot.h doesn't need to include necessary headers
> for its functions and structures because the files that include it already
> do it.
> 
> But boot.h could be needed as well for further uses on other files.
> So, this patch adds the necessary headers for future purposes...
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/tracing/fastboot, thanks!

	Ingo
