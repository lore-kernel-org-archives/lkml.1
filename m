Return-Path: <linux-kernel-owner+w=401wt.eu-S937916AbXHGWBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937916AbXHGWBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965684AbXHGVhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:37:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966605AbXHGVhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:37:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add linux/elfcore-compat.h
In-Reply-To: Andrew Morton's message of  Tuesday, 7 August 2007 13:28:50 -0700 <20070807132850.a7e81f97.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Emacs: well, why *shouldn't* you pay property taxes on your editor?
Message-Id: <20070807213658.C586A4D04C4@magilla.localdomain>
Date: Tue,  7 Aug 2007 14:36:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Should ia64 be using this too?

It's a clean-up that every arch with compat core dumping code can benefit from.
I only touched the ones I have handy to test at home.  Doing the same for
each other arch should be straightforward, and I'm happy to offer tips.


Thanks,
Roland
