Return-Path: <linux-kernel-owner+w=401wt.eu-S932523AbZJFMkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbZJFMkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932438AbZJFMkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:40:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37067 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399AbZJFMkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:40:35 -0400
Date: Tue, 6 Oct 2009 14:39:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
Subject: Re: [RFC][PATCH 8/9] perf trace: Add perf trace scripting support
	modules for Perl
Message-ID: <20091006123944.GA15320@elte.hu>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com> <1254809398-8078-9-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254809398-8078-9-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tom Zanussi <tzanussi@gmail.com> wrote:

> --- /dev/null
> +++ b/tools/perf/scripts/perl/Perf-Trace-Util/Changes
> @@ -0,0 +1,6 @@
> +Revision history for Perl extension Perf::Trace::Util.
> +
> +0.01  Fri Sep 25 12:08:40 2009
> +	- original version; created by h2xs 1.23 with options
> +		-AXn Perf::Trace::Util
> +

is this needed? We have Git history which is far more flexible than 
in-source changelogs.

	Ingo
