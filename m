Return-Path: <linux-kernel-owner+w=401wt.eu-S935482AbXJQACt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935482AbXJQACt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 20:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbXJQACk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 20:02:40 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:52800 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbXJQACj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 20:02:39 -0400
From: Markus <lists4me@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v19
Date: Wed, 17 Oct 2007 02:02:30 +0200
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-Id: <200710170202.31914.lists4me@web.de>
X-Provags-ID: V01U2FsdGVkX1/XScPzV3mMF6nuXFG421c9hkE639jtQ9NphjGC
	MNLkRJZN23N54rvh82VrFuMMsZ8H8RZ5TJp03E9xA1E/mrRfgj
	ofL6UJubs=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I am now running a 2.6.22 (without cfs) and could now see it once 
(within a month...) that exactly the same message from konqueror was 
produced.
So I think its a general problem of konqueror that was hidden and 
somehow its triggered much more often with the cfs.

I just wonder why nobody else has this problem.

   Markus

PS: I am currently building a 2.6.23.1...
