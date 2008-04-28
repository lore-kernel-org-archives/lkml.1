Return-Path: <linux-kernel-owner+w=401wt.eu-S937280AbYD1V3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937280AbYD1V3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965937AbYD1V1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:27:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:24531 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965763AbYD1V1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=FW9NM6lchC233/IGKm4MBfxD+BFLdAdHUeovJSxPTZHk6lZkE+UdrQaupWw27n5fogfsf5wFS7BpB+JAMnX6KIx/0fcuvmcsp7ruw9sY6j3B4y79/vN6Ej3iDi/7bfck0a0twSSM5kKmmUxYSMmfffSjxy1dcKjZtwHnBZ1kOqE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: add TSSTcorp CDDVDW SH-S202H to ivb_list[]
Date: Mon, 28 Apr 2008 23:42:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Alexander Smal <avsmal@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804282342.08448.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Smal <avsmal@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -625,6 +625,8 @@ static const struct drive_list_entry ivb
 	{ "TSSTcorp CDDVDW SH-S202J"	, "SB01"	},
 	{ "TSSTcorp CDDVDW SH-S202N"	, "SB00"	},
 	{ "TSSTcorp CDDVDW SH-S202N"	, "SB01"	},
+	{ "TSSTcorp CDDVDW SH-S202H"	, "SB00"	},
+	{ "TSSTcorp CDDVDW SH-S202H"	, "SB01"	},
 	{ NULL				, NULL		}
 };
 
