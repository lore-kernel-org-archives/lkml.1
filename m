Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbZKPVFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbZKPVFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZKPVFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:05:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53859 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbZKPVFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:05:21 -0500
Date: Mon, 16 Nov 2009 19:05:18 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5/5] perf buildid-list: New plumbing command
Message-ID: <20091116210518.GB28963@ghostprotocols.net>
References: <1258396365-29217-1-git-send-email-acme@infradead.org> <1258396365-29217-2-git-send-email-acme@infradead.org> <1258396365-29217-3-git-send-email-acme@infradead.org> <1258396365-29217-4-git-send-email-acme@infradead.org> <1258396365-29217-5-git-send-email-acme@infradead.org> <20091116210242.GB6984@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116210242.GB6984@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 16, 2009 at 10:02:42PM +0100, Ingo Molnar escreveu:
> 
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
> > +++ b/tools/perf/command-list.txt
> > @@ -4,6 +4,7 @@
> >  #
> >  perf-annotate			mainporcelain common
> >  perf-bench			mainporcelain common
> > +perf-build-list			mainporcelain common
> 
> s/build-list/buildid-list

Ooops, do you want me to resent the whole series or can you please fix
this up while merging? :)

- Arnaldo
