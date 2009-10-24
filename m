Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbZJXPmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbZJXPmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 11:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZJXPmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 11:42:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46057 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbZJXPmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 11:42:02 -0400
Date: Sat, 24 Oct 2009 17:41:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marti Raudsepp <marti@juffo.org>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: add compatibility with libelf 0.8 and
	autodetect
Message-ID: <20091024154151.GA24876@elte.hu>
References: <1256330234-14079-1-git-send-email-marti@juffo.org> <20091023210231.GC8356@elte.hu> <1256334501-15755-1-git-send-email-marti@juffo.org> <193b0f820910231807t35f8b462r1f92e28492b780e2@mail.gmail.com> <20091024083031.GB20575@elte.hu> <193b0f820910240626m1567190cqc40930542453319d@mail.gmail.com> <1256397192.24594.13.camel@newn> <1256397564.24594.16.camel@newn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256397564.24594.16.camel@newn>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marti Raudsepp <marti@juffo.org> wrote:

> Re-sending small fix; somehow I typed "elf_c_read_mmap" in lower case 
> in the comment.

The patch got whitespace damaged (tabs are spaces, etc.) - please see 
Documentation/email-clients.txt.
 
	Ingo
