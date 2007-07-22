Return-Path: <linux-kernel-owner+w=401wt.eu-S1764826AbXGVKYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764826AbXGVKYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 06:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbXGVKYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 06:24:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbXGVKYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 06:24:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andi Kleen <ak@suse.de>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 vDSO: install unstripped copies on disk
In-Reply-To: Andi Kleen's message of  Sunday, 22 July 2007 11:24:59 +0200 <200707221124.59784.ak@suse.de>
Emacs: ballast for RAM.
Message-Id: <20070722102355.697514D05C1@magilla.localdomain>
Date: Sun, 22 Jul 2007 03:23:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, how would the debugger find them? There won't be any reference 
> from the vdso to them.

Soon the norm will be to use the --build-id bits.

