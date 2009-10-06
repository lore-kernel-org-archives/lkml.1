Return-Path: <linux-kernel-owner+w=401wt.eu-S932476AbZJFMql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbZJFMql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932257AbZJFMqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:46:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33368 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932224AbZJFMqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:46:40 -0400
Date: Tue, 6 Oct 2009 14:45:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
Subject: Re: [RFC][PATCH 8/9] perf trace: Add perf trace scripting support
	modules for Perl
Message-ID: <20091006124550.GB15320@elte.hu>
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
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tom Zanussi <tzanussi@gmail.com> wrote:

> +++ b/tools/perf/scripts/perl/Perf-Trace-Util/README
> @@ -0,0 +1,30 @@
> +Perf-Trace-Util version 0.01
> +============================
> +
> +This module contains utility functions for use with perf trace.
> +
> +INSTALLATION
> +
> +Building perf with perf trace Perl scripting should install this
> +module in the right place.
> +
> +You should make sure libperl is installed first e.g. apt-get install
> +libperl-dev.
> +
> +DEPENDENCIES
> +
> +This module requires these other modules and libraries:
> +
> +  blah blah blah

Some fixing needed here i guess ;-)

> +COPYRIGHT AND LICENCE
> +
> +Put the correct copyright and licence information here.
> +
> +Copyright (C) 2009 by Tom Zanussi <tzanussi@gmail.com>
> +
> +This library is free software; you can redistribute it and/or modify
> +it under the same terms as Perl itself, either Perl version 5.10.0 or,
> +at your option, any later version of Perl 5 you may have available.

Would be nice to dual license it to the kernel (GPLv2) as well.

	Ingo
