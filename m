Return-Path: <linux-kernel-owner+w=401wt.eu-S932525AbZACH4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbZACH4V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZACH4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:56:13 -0500
Received: from vps1.tull.net ([66.180.172.116]:37927 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750759AbZACH4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:56:12 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 06/11] Fix misspelling of "firmware" in megaraid.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 03 Jan 2009 18:55:39 +1100
Message-ID: <20090103075528.27466.52833.stgit@marcab.local>
In-Reply-To: <20090103074923.27466.7287.stgit@marcab.local>
References: <20090103074923.27466.7287.stgit@marcab.local>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of "firmware" in megaraid.c

Fixed "firmware", "ownership" and grammar in the same comment.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/scsi/megaraid.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 7dc62de..9fdcd60 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1967,8 +1967,8 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 			scb->state |= aor;
 
 			/*
-			 * Check if this command has firmare owenership. If
-			 * yes, we cannot reset this command. Whenever, f/w
+			 * Check if this command has firmware ownership. If
+			 * yes, we cannot reset this command. Whenever f/w
 			 * completes this command, we will return appropriate
 			 * status from ISR.
 			 */

