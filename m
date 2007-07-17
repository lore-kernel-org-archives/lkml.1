Return-Path: <linux-kernel-owner+w=401wt.eu-S933868AbXGQWD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbXGQWD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbXGQWDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:03:19 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:62833 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbXGQWDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:03:17 -0400
From: Markus <lists4me@web.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v19
Date: Wed, 18 Jul 2007 00:03:13 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070706173319.GA2356@elte.hu> <alpine.LFD.0.999.0707171329370.27353@woody.linux-foundation.org> <20070717204358.GA12037@elte.hu>
In-Reply-To: <20070717204358.GA12037@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707180003.14137.lists4me@web.de>
X-Provags-ID: V01U2FsdGVkX1/7xoOTgtXh78Me1AudnRdgWlxnjc58TQO5Sno0
	Y7P5X0XArIHKcRBpBOZPZaIi/jnY9CjrXHinv+Ynx7emtT394y
	J0oGDBcj4=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> hm, Markus indicated that he tried the v2.6.21.6-cfsv19 patch, and 
that 
> does not include the time.c change. Markus - does your kernel include 
> the code below? (if yes, please revert it via patch -p1 -R )
Well, the 2.6.22.1-cfs-v19 does include it, but the 2.6.21.6-cfs-v19 
does not have that patch applied.
But both show this problem.

   Markus
