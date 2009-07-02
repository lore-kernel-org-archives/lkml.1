Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbZGBR3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbZGBR3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZGBR2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:28:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39108 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbZGBR22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:28:28 -0400
Date: Thu, 2 Jul 2009 19:25:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ratan Nalumasu <rnalumasu@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] do_wait() wakeup optimization
Message-ID: <20090702172506.GA24078@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On top of
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch

The first two patches were not changed, just re-diff against the fix above.

The 3rd one is new.

Oleg.

