Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZHZKQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZHZKQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbZHZKQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:16:17 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:62748 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669AbZHZKQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=UqmQiukLotq6U5twPiUERvYG0v3H1IdyOpEZ7fjS/wXeoxfeHY3rzMRIp+qxFhOuXc
         Dl/h5L0aJ14nQQLYMTEsIZKLo7Ox81I2Rr5dnasMqErxAPJUUvWqYKBk6cRIesdB4X6s
         AJAMcvBft3RCn9I49cCdcHKMpu/bO2PweEbGw=
From: Giuseppe Scrivano <gscrivano@gnu.org>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH] documentation: update the ioctl numbers list
Date: Wed, 26 Aug 2009 12:17:36 +0200
Message-ID: <87my5mnakf.fsf@gnu.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

shouldn't the ioctl number used by the BTRFS file system be mentioned in
the documentation ioctl numbers list?

Cheers,
Giuseppe


>From 8cc465afd0bcfcb8930593af667f12a9ee096d01 Mon Sep 17 00:00:00 2001
From: Giuseppe Scrivano <gscrivano@gnu.org>
Date: Wed, 26 Aug 2009 11:33:49 +0200
Subject: [PATCH] documentation: update the ioctl numbers list

Mention the ioctl number used by BTRFS.
---
 Documentation/ioctl/ioctl-number.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 1f779a2..fe91e3e 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -177,6 +177,7 @@ Code	Seq#	Include File		Comments
 					<http://www.proximity.com.au/~brian/winradio/>
 0x90	00	drivers/cdrom/sbpcd.h
 0x93	60-7F	linux/auto_fs.h
+0x94	01-0E	fs/btrfs/ioctl.h	BTRFS
 0x99	00-0F				537-Addinboard driver
 					<mailto:buk@buks.ipn.de>
 0xA0	all	linux/sdp/sdp.h		Industrial Device Project
-- 
1.6.3.3
