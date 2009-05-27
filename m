Return-Path: <linux-kernel-owner+w=401wt.eu-S933373AbZE0ST5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373AbZE0ST5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932564AbZE0STr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:19:47 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2932 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933138AbZE0STq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:19:46 -0400
Subject: [PATCH] MAINTAINERS: Add Paul McKenney to RCU and RCUTORTURE
From: Joe Perches <joe@perches.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Josh Triplett <josh@freedesktop.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090526234241.GD7006@linux.vnet.ibm.com>
References: <cover.1243131992.git.joe@perches.com>
	 <9f55522f7ab56afcf16d936d06ab2f3a7e699ed5.1243131992.git.joe@perches.com>
	 <20090526234241.GD7006@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 27 May 2009 11:18:36 -0700
Message-Id: <1243448316.27337.28.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 16:42 -0700, Paul E. McKenney wrote:
> Hmmm...  Given that you are removing LKML from RCU and rcutorture,
> could you please add me?  If someone misses "THE REST", I very likely
> won't see their bug/issue/question.
> 
> P:	Paul E. McKenney
> M:	paulmck@linux.vnet.ibm.com

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ab45488..0426b39 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4630,6 +4630,8 @@ F:	drivers/net/wireless/ray*
 RCUTORTURE MODULE
 P:	Josh Triplett
 M:	josh@freedesktop.org
+P:	Paul E. McKenney
+M:	paulmck@linux.vnet.ibm.com
 S:	Maintained
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
@@ -4656,6 +4658,8 @@ F:	net/rds/
 READ-COPY UPDATE (RCU)
 P:	Dipankar Sarma
 M:	dipankar@in.ibm.com
+P:	Paul E. McKenney
+M:	paulmck@linux.vnet.ibm.com
 W:	http://www.rdrop.com/users/paulmck/rclock/
 S:	Supported
 F:	Documentation/RCU/rcu.txt


