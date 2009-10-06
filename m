Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbZJFNAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbZJFNAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757216AbZJFNAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:00:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:37053 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213AbZJFNAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:00:40 -0400
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Valdis.Kletnieks@vt.edu,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Byron Stanoszek <bstanoszek@comtime.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain>
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>
	 <alpine.LFD.2.01.0910051110200.3432@localhost.localdomain>
	 <b6a2187b0910051715y4ee63503y148ba2d7e24cad8e@mail.gmail.com>
	 <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 13:59:34 +0100
Message-Id: <1254833974.14541.1306.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 17:30 -0700, Linus Torvalds wrote:
> In fact, I wish more people did that, just so that we'd get better 
> coverage of the 32-bit compat code. We occasionally find issues there,
> although I think it's getting rarer.

We've been running PPC64 with 32-bit userspace for a long time, so most
of the issues with the 32-bit compat code ought to be dealt with.

There may be a few arch-specific issues for x86_64/i386, but not many.

-- 
dwmw2

