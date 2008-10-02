Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbYJBNTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbYJBNTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbYJBNSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:18:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53615 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbYJBNSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:18:44 -0400
Message-Id: <20081002130504.927878499@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 02 Oct 2008 15:05:04 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Neil Brown <neilb@suse.de>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 00/32] Swap over NFS - v19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches are against: v2.6.27-rc5-mm1

This release features more comments and (hopefully) better Changelogs.
Also the netns stuff got sorted and ipv6 will now build and not oops
on boot ;-)

The first 4 patches are cleanups and can go in if the respective maintainers
agree.

The code is lightly tested but seems to work on my default config.

Let's get this ball rolling...

