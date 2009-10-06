Return-Path: <linux-kernel-owner+w=401wt.eu-S932533AbZJFNKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533AbZJFNKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932257AbZJFNKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:10:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44269 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226AbZJFNKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:10:23 -0400
Date: Tue, 6 Oct 2009 15:09:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
Subject: Re: [RFC][PATCH 0/9] perf trace: support for general-purpose
	scripting
Message-ID: <20091006130934.GA18365@elte.hu>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0070]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tom Zanussi <tzanussi@gmail.com> wrote:

>   tracing/events: Add 'signed' field to format files
>   perf trace: Add subsystem string to struct event
>   perf trace: Add string/dynamic cases to format_flags

I've applied these three patches to tip:perf/core, as they are fine 
as-is standalone. This should ease the iteration of the remaining 
patches.

Thanks,

	Ingo
