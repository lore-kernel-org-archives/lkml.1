Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbXGOTs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbXGOTs2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 15:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbXGOTsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:48:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:56778 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750832AbXGOTsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:48:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ND1ok/p9NF/wsddt9qTZsECV5V8pj6SxJk79yZn
	CWp7ZO85YQuSim
Subject: Re: [patch] CFS scheduler, -v19
From: Mike Galbraith <efault@gmx.de>
To: Markus <lists4me@web.de>
Cc: Ed Tomlinson <edt@aei.ca>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <200707151453.57725.lists4me@web.de>
References: <20070706173319.GA2356@elte.hu> <200707141319.13270.edt@aei.ca>
	 <1184477133.6378.21.camel@Homer.simpson.net>
	 <200707151453.57725.lists4me@web.de>
Content-Type: text/plain
Date: Sun, 15 Jul 2007 21:46:31 +0200
Message-Id: <1184528791.6324.41.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-15 at 14:53 +0200, Markus wrote:
> [1] http://lkml.org/lkml/2007/07/14/60

Hm.  Tasks disappearing isn't you're typical process scheduler problem
by any means, nor is an idle box exhibiting mouse "lurchiness".  Is
there anything unusual in your logs?

	-Mike

