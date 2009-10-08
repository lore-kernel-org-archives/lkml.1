Return-Path: <linux-kernel-owner+w=401wt.eu-S932779AbZJHX06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbZJHX06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbZJHX0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:26:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:43303 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759933AbZJHX0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:26:53 -0400
Message-Id: <20091008232226.768382977@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 09 Oct 2009 01:22:26 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 0/4] stack based kmap_atomic -v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest bits..

Maybe FRV can do a kind of kmap-stack switch on (soft)irq enter/exit
in order to stay below 5 entries.

Will continue prodding tomorrow, sleep time here.


