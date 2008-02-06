Return-Path: <linux-kernel-owner+w=401wt.eu-S1763477AbYBFNp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763477AbYBFNp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 08:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbYBFNpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 08:45:13 -0500
Received: from styx.suse.cz ([82.119.242.94]:44700 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757126AbYBFNpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:45:12 -0500
Date: Wed, 6 Feb 2008 14:45:11 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] brk and randomization fixes
Message-ID: <Pine.LNX.4.64.0802061438150.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

the following two patches are the outcome of the thread "brk randomization 
breaks columns" [1]. As brk randomization is already in Linus' tree, it's 
definitely 2.6.25 material, so it would probably be good if you could push 
them in your next bunch going to Linus, if noone has any objections.

I think it's better if they go through you than through Ingo, as they are 
not x86-specific at all.

Thanks.

[1] http://lkml.org/lkml/2008/2/4/83

-- 
Jiri Kosina
SUSE Labs
