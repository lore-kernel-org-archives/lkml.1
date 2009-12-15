Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbZLOQLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbZLOQLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 11:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759393AbZLOQLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 11:11:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759374AbZLOQLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 11:11:52 -0500
Date: Tue, 15 Dec 2009 14:11:20 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/3] perf symbols: Make symbol_conf global
Message-ID: <20091215161120.GH21796@ghostprotocols.net>
References: <1260892717-20841-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260892717-20841-1-git-send-email-acme@infradead.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 15, 2009 at 01:58:35PM -0200, Arnaldo Carvalho de Melo escreveu:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> This simplifies a lot of functions, less stuff to be done by tool
> writers.

Ingo, this clashes with the batch Masami-san just submitted, please
defer applying my series so that I can rework it to take into account
the changes that Masami-san contributed.

Thanks!

- Arnaldo
