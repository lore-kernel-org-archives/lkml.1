Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385Ab0ASMkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab0ASMkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 07:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688Ab0ASMks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 07:40:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53927 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab0ASMks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 07:40:48 -0500
Date: Tue, 19 Jan 2010 10:40:37 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jamie Iles <jamie.iles@picochip.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/2] perf symbols: If only --vmlinux if specified
Message-ID: <20100119124037.GB9423@ghostprotocols.net>
References: <1263904574-30732-1-git-send-email-acme@infradead.org> <1263904574-30732-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263904574-30732-2-git-send-email-acme@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 19, 2010 at 10:36:14AM -0200, Arnaldo Carvalho de Melo escreveu:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Found while analysing a perf.data file collected on an ARM machine where
> an explicitely specified vmlinux was being disregarded.
> 

Sorry, the patch title should read:

"perf symbols: Use only --vmlinux if specified"

- Arnaldo
