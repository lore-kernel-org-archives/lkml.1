Return-Path: <linux-kernel-owner+w=401wt.eu-S1752370AbZIXXHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbZIXXHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 19:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZIXXHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 19:07:20 -0400
Received: from mail.perches.com ([173.55.12.10]:1186 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbZIXXHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 19:07:19 -0400
Subject: [PATCH V2] MAINTAINERS: Update Kernel Janitors after mismerge
From: Joe Perches <joe@perches.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Markus Heidelberg <markus.heidelberg@web.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200909242142.n8OLgm6x026791@imap1.linux-foundation.org>
References: <200909242142.n8OLgm6x026791@imap1.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Sep 2009 16:07:22 -0700
Message-Id: <1253833642.1806.92.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 14:42 -0700, akpm@linux-foundation.org wrote:
> The patch titled
>      MAINTAINERS: JANITORS status set to Odd Fixes
> Subject: MAINTAINERS: JANITORS status set to Odd Fixes
> It was mistakenly reset to MAINTAINED after a fuzzy merge

This is a better patch.
It fixes the mismerge of the W: URL and the S: status fields.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0aa0776..ba70091 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2954,8 +2954,8 @@ F:	scripts/Makefile.*
 
 KERNEL JANITORS
 L:	kernel-janitors@vger.kernel.org
-W:	http://www.kerneljanitors.org/
-S:	Maintained
+W:	http://janitor.kernelnewbies.org/
+S:	Odd Fixes
 
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 M:	"J. Bruce Fields" <bfields@fieldses.org>


