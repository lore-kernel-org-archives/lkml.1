Return-Path: <linux-kernel-owner+w=401wt.eu-S932576AbZHDIGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576AbZHDIGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932249AbZHDIGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:06:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46523 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230AbZHDIGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:06:09 -0400
Date: Tue, 4 Aug 2009 10:06:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Paul Mundt <lethal@linux-sh.org>, Thomas Gelixner <tglx@linuxtronix.de>
Subject: Re: [PATCH 0/2] Resend of ftrace recordmcount.pl fixes
Message-ID: <20090804080602.GA18635@elte.hu>
References: <cover.1249365713.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1249365713.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> I'm resending these two patches as they seem to be stalled.
> 
> Matt Fleming (2):
>   ftrace: Fix the conditional that updates $ref_func
>   ftrace: Only update $offset when we update $ref_func
> 
>  scripts/recordmcount.pl |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)

Applied to tip:tracing/urgent, thanks Matt!

	Ingo
