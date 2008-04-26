Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYDZJ7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYDZJ7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 05:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYDZJ7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 05:59:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:62841 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYDZJ7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 05:59:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent:from;
        b=mQSsHIoddR6zxE0ehgFR/8yVChfRTYoOUpEuixm/Kc6JnYKkJtyMDoiSxNYi+jxr9d8UUO+5OsVhJQBXxJhaq5pwz+xF6iGV9dCnr3FBeIq3yc2Aq249bZu97CCxWndZ+q1kVu0h+DhA+Lj/ZVNnnI8tk/r+VcpkSMsXT/OpF4I=
Date: Sat, 26 Apr 2008 11:59:24 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, hpa@zytor.com
Subject: Re: [git pull] kmemcheck
Message-ID: <20080426095924.GA25510@damson.getinternet.no>
Reply-To: 20080425230934.c54a07a0.akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/08, Andrew Morton <akpm@linux-foundation.org> wrote:
> Can we have a MAINTAINERS update please?
>

I guess I should volunteer for that position.

Like this?


>From ab5fe5ca22a9b3243fd711482ad6e19f8c09c223 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sat, 26 Apr 2008 11:47:07 +0200
Subject: [PATCH] MAINTAINERS: add entry for kmemcheck

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e467758..6fbed2c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2319,6 +2319,11 @@ L:	linux-kernel@vger.kernel.org
 L:	kexec@lists.infradead.org
 S:	Maintained
 
+KMEMCHECK
+P:	Vegard Nossum
+M:	vegardno@ifi.uio.no
+S:	Maintained
+
 KPROBES
 P:	Ananth N Mavinakayanahalli
 M:	ananth@in.ibm.com
-- 
1.5.4.1

