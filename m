Return-Path: <linux-kernel-owner+w=401wt.eu-S1753038AbZHJUTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbZHJUTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZHJUTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:19:35 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2828 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZHJUTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:19:35 -0400
Subject: [PATCH] MAINTAINERS: Add Matt Mackall and Herbert Xu to HARDWARE
 RANDOM NUMBER GENERATOR
From: Joe Perches <joe@perches.com>
To: Matt Mackall <mpm@selenic.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
       Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mips <linux-mips@linux-mips.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <1249934094.3807.32.camel@calx>
References: <4A806529.3060609@caviumnetworks.com>
	 <1249934094.3807.32.camel@calx>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 13:18:29 -0700
Message-Id: <1249935509.8895.63.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 14:54 -0500, Matt Mackall wrote:
> On Mon, 2009-08-10 at 11:21 -0700, David Daney wrote:
> > I am copying AKPM and Linus as there seems to be no hw_random maintainer.
> These now go through Herbert Xu and I.

Perhaps this then:

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b1114cf..9a27822 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2260,7 +2260,9 @@ S:	Orphan
 F:	drivers/hwmon/
 
 HARDWARE RANDOM NUMBER GENERATOR CORE
-S:	Orphan
+M:	Matt Mackall <mpm@selenic.com>
+M:	Herbert Xu <herbert@gondor.apana.org.au>
+S:	Odd fixes
 F:	Documentation/hw_random.txt
 F:	drivers/char/hw_random/
 F:	include/linux/hw_random.h



