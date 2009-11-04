Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbZKDNa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbZKDNa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbZKDNa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:30:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:44231 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182AbZKDNa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:30:58 -0500
Date: Wed, 4 Nov 2009 11:30:32 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric=5FWeisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH v3 0/7] Adding general performance benchmarking
	subcommand to perf.
Message-ID: <20091104133032.GD2603@ghostprotocols.net>
References: <1257339987-22953-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257339987-22953-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 04, 2009 at 10:06:20PM +0900, Hitoshi Mitake escreveu:
> This patch series add general benchmark subcommand to perf.
> 
> The subcommand will unify the benchmarking programs
> and provide these in standardized way.
> 
> Hitoshi Mitake (7):
>   Adding general performance benchmarking subcommand to perf.
>   Adding general performance benchmarking subcommand to perf.
>   Adding general performance benchmarking subcommand to perf.
>   Adding general performance benchmarking subcommand to perf.
>   Adding general performance benchmarking subcommand to perf.
>   Adding general performance benchmarking subcommand to perf.
>   Adding general performance benchmarking subcommand to perf.

Why do you use the same description for all patches in this series?

- Arnaldo
