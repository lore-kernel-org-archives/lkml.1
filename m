Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbZKXBUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbZKXBUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757705AbZKXBUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:20:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45982 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670AbZKXBUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:20:37 -0500
Date: Mon, 23 Nov 2009 23:20:30 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] perf kmem: resolve symbols
Message-ID: <20091124012030.GB9654@ghostprotocols.net>
References: <1259005869-13487-1-git-send-email-acme@infradead.org> <1259005869-13487-2-git-send-email-acme@infradead.org> <4B0B2DF1.1010603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0B2DF1.1010603@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 24, 2009 at 08:50:57AM +0800, Li Zefan escreveu:
> Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> >  tools/perf/builtin-kmem.c |   37 +++++++++++++++++++++++--------------
> >  1 files changed, 23 insertions(+), 14 deletions(-)
> 
> I was about to send out my version. Any, thanks for doing this!

Ok, I'll have some sleep now, hack away! :-)

- Arnaldo
