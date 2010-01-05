Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400Ab0AETWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0AETWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373Ab0AETWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:22:12 -0500
Received: from kroah.org ([198.145.64.141]:55834 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab0AETWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:22:10 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 101/101] Linux 2.6.32.3-rc2
Date: Tue,  5 Jan 2010 11:21:29 -0800
Message-Id: <1262719290-310-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262719290-310-3-git-send-email-gregkh@suse.de>
References: <20100105192014.GA23628@kroah.com>
 <1262719290-310-1-git-send-email-gregkh@suse.de>
 <1262719290-310-2-git-send-email-gregkh@suse.de>
 <1262719290-310-3-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index f870e02..dfdff4d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .3-rc1
+EXTRAVERSION = .3-rc2
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
-- 
1.6.6

