Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbYLHMyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbYLHMyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 07:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbYLHMy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 07:54:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57982 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbYLHMy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 07:54:27 -0500
Date: Mon, 8 Dec 2008 13:54:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ring_buffer: fix comments
Message-ID: <20081208125419.GE16560@elte.hu>
References: <493C8D40.9000203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493C8D40.9000203@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0428]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Impact: comments cleanup
> 
> fix incorrect comments for enum ring_buffer_type
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

applied to tip/tracing/ring-buffer, thanks!

	Ingo
