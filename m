Return-Path: <linux-kernel-owner+w=401wt.eu-S1763340AbYBUDeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763340AbYBUDeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 22:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYBUDeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 22:34:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbYBUDeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 22:34:09 -0500
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: include/asm-x86/desc_64.h is empty
X-Windows: some voids are better left unfilled.
Message-Id: <20080221033403.32F9E2701D5@magilla.localdomain>
Date: Wed, 20 Feb 2008 19:34:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/asm-x86/desc_64.h should have been removed, but is still in the
tree containing just a newline.


Thanks,
Roland
