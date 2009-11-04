Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbZKDPgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbZKDPgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZKDPgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:36:53 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62556 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbZKDPgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:36:52 -0500
Date: Thu, 05 Nov 2009 00:36:50 +0900 (JST)
Message-Id: <20091105.003650.886429907132167233.mitake@dcl.info.waseda.ac.jp>
To: acme@infradead.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com
Subject: Re: [PATCH v3 0/7] Adding general performance benchmarking
 subcommand to perf.
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091104133032.GD2603@ghostprotocols.net>
References: <1257339987-22953-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<20091104133032.GD2603@ghostprotocols.net>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH v3 0/7] Adding general performance benchmarking subcommand to perf.
Date: Wed, 4 Nov 2009 11:30:32 -0200

> Em Wed, Nov 04, 2009 at 10:06:20PM +0900, Hitoshi Mitake escreveu:
> > This patch series add general benchmark subcommand to perf.
> > 
> > The subcommand will unify the benchmarking programs
> > and provide these in standardized way.
> > 
> > Hitoshi Mitake (7):
> >   Adding general performance benchmarking subcommand to perf.
> >   Adding general performance benchmarking subcommand to perf.
> >   Adding general performance benchmarking subcommand to perf.
> >   Adding general performance benchmarking subcommand to perf.
> >   Adding general performance benchmarking subcommand to perf.
> >   Adding general performance benchmarking subcommand to perf.
> >   Adding general performance benchmarking subcommand to perf.
> 
> Why do you use the same description for all patches in this series?
> 
> - Arnaldo
> 

Sorry, this naming is too confusable.
I'll fix and resend.
