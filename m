Return-Path: <linux-kernel-owner+w=401wt.eu-S1762636AbZC0AMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762636AbZC0AMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZC0ALA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:11:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44016 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbZC0AK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:10:59 -0400
Date: Fri, 27 Mar 2009 01:06:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Lojkin <ia6432@inbox.ru>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH 0/2] posix-timers: RLIMIT_CPU fixes
Message-ID: <20090327000603.GA10097@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These bugs (introduced in 2.6.28) are not serious, but I cc'ed -stable team.

The first patch is for 2.6.29 only, I can re-do it for 2.6.28 if needed.

The second one applies to both.

Oleg.

