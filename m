Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbZHSUTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbZHSUTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 16:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZHSUTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 16:19:33 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:64488 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbZHSUTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 16:19:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=ZTCHf/j/xlILBaZKasJffmNfy8TN+bh9sdut3k0l1sN6XK1cO0VB2ncuh8Qzf7Z/wy
         fzo0IX4ldVQzXv8pqIJ5aSsqzt4LDf/Hmfp/AX1ouEdt2Ostuq/DlvIJokwf5bhBlv80
         zrPfvhoSJjcosJnvthIjnHOZOaJw6+taoQYQQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] MAINTAINERS: remove dead ncpfs list
Date: Wed, 19 Aug 2009 22:19:09 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc6-dirty; KDE/4.2.4; i686; ; )
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908192219.09911.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] MAINTAINERS: remove dead ncpfs list

On Saturday 01 August 2009 00:30:39 Mail Delivery Subsystem wrote:
> Delivery to the following recipient failed permanently:
> 
>      linware@sh.cvut.cz
> 
> Technical details of permanent failure: 
> Google tried to deliver your message, but it was rejected by the recipient
> domain. We recommend contacting the other email provider for further
> information about the cause of this error. The error that the other server
> returned was: 450 450 <linware@sh.cvut.cz>: Recipient address rejected:
> undeliverable address: unknown user: "linware" (state 14).

Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

Index: b/MAINTAINERS
===================================================================
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3464,7 +3464,6 @@ F:	drivers/net/natsemi.c
 
 NCP FILESYSTEM
 M:	Petr Vandrovec <vandrove@vc.cvut.cz>
-L:	linware@sh.cvut.cz
 S:	Maintained
 F:	fs/ncpfs/
 
