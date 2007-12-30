Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbXL3Nmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbXL3Nmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbXL3Nmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:42:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40114 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbXL3Nmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:42:32 -0500
Date: Sun, 30 Dec 2007 14:42:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Introduce REX prefix helper for kprobes
Message-ID: <20071230134212.GG16946@elte.hu>
References: <1198466795.6323.12.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198466795.6323.12.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Fold some small ifdefs into a helper function.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

thanks, applied.

	Ingo
