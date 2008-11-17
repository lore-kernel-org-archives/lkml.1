Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbYKQNjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbYKQNjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYKQNjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:39:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46102 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbYKQNjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:39:12 -0500
Date: Mon, 17 Nov 2008 15:39:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>
Cc: Doug Chapman <doug.chapman@hp.com>, Frank Mayhar <fmayhar@google.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] more fixes for "timers: fix itimer/many thread hang"
Message-ID: <20081117143938.GA5352@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile tested, please review.

The first one is imho 2.6.28 material, others are cleanups.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>


