Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704Ab0A2Uec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab0A2Uec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335Ab0A2Ueb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:34:31 -0500
Received: from mail.perches.com ([173.55.12.10]:1608 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab0A2Ueb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:34:31 -0500
Subject: [PATCH] MAINTAINERS: Make BEFS an orphan
From: Joe Perches <joe@perches.com>
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       Sergey Kostyliov <rathamahata@gmail.com>
Cc: linux-kernel@vger.kernel.org, siccegge@i4.informatik.uni-erlangen.de,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100129134230.GA14155@faui49.informatik.uni-erlangen.de>
References: <20100129134230.GA14155@faui49.informatik.uni-erlangen.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 12:34:29 -0800
Message-ID: <1264797270.25140.82.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 14:42 +0100, Christoph Egger wrote:
> 	Just noticed that the E-Mail Address for BEFS' Maintainer[0]
> doesn't work any more[1]. Maybe the Address could be fixed if someone
> knows the correct (as in wanted) E-Mail Address (I assume @gmail.com
> could be fine).
> [0] Sergey S. Kostyliov <rathamahata@php4.ru> (maintainer:BEFS FILE SYSTEM)
> [1]
>   <rathamahata@php4.ru>: host mail.php4.ru[62.90.175.121] said: 553 5.3.0
>     <rathamahata@php4.ru>... No such user here (in reply to RCPT TO command)

Hello Sergey.

You haven't submitted or acked a patch for quite awhile.
Do you still want to be listed as a maintainer for BEFS?

Perhaps this is appropriate?

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f19e098..9ca645a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1189,8 +1189,7 @@ S:	Maintained
 F:	drivers/net/hamradio/baycom*
 
 BEFS FILE SYSTEM
-M:	"Sergey S. Kostyliov" <rathamahata@php4.ru>
-S:	Maintained
+S:	Orphan
 F:	Documentation/filesystems/befs.txt
 F:	fs/befs/
 


