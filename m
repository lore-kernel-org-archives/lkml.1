Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbZBDTr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbZBDTr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbZBDTro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:47:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42557 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758577AbZBDTrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:47:43 -0500
Date: Wed, 4 Feb 2009 20:47:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH tip 1/1] trace: Make the trace_event callbacks return
	enum print_line_t
Message-ID: <20090204194734.GD22608@elte.hu>
References: <20090203222041.GE3440@ghostprotocols.net> <20090203224933.GG6344@nowhere> <20090204000550.GH3440@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204000550.GH3440@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> As they actually all return these enumerators.
>     
> Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 

applied	to tip:tracing/ftrace, thanks Arnaldo!

	Ingo

ps. the diffstat was missing - it's usually handy on lkml
