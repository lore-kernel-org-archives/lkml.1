Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbXGOMyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbXGOMyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 08:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbXGOMyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 08:54:02 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:52806 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbXGOMyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 08:54:00 -0400
From: Markus <lists4me@web.de>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [patch] CFS scheduler, -v19
Date: Sun, 15 Jul 2007 14:53:57 +0200
User-Agent: KMail/1.9.5
Cc: Ed Tomlinson <edt@aei.ca>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20070706173319.GA2356@elte.hu> <200707141319.13270.edt@aei.ca> <1184477133.6378.21.camel@Homer.simpson.net>
In-Reply-To: <1184477133.6378.21.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707151453.57725.lists4me@web.de>
X-Provags-ID: V01U2FsdGVkX19XmICpPO3AX8yPlCEehFurtOgMvq8nV6x9Ihgk
	lYwplp9HActGjJR3crT+p3Py6JzO4vux3hi9qOh//0ts47O0U/
	Xr5nmTBz0=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Sending a few seconds of logged /proc/sched_debug will also help get a
> picture of what's happening, and lovely would be a method to reproduce
> the problem locally.

Hi. Is there anything like the sched_debug in the 2.6.22-git5?
Because I have a cfs-problem as well [1].

   Markus


[1] http://lkml.org/lkml/2007/07/14/60
