Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655Ab0AEAhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab0AEAhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633Ab0AEAha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:37:30 -0500
Received: from kroah.org ([198.145.64.141]:42563 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab0AEAgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:24 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 97/97] Linux 2.6.32.3-rc1
Date: Mon,  4 Jan 2010 16:33:50 -0800
Message-Id: <1262651630-7354-97-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 23803ce..f870e02 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .2
+EXTRAVERSION = .3-rc1
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
-- 
1.6.6

