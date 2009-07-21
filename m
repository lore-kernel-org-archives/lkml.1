Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbZGUMxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbZGUMxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 08:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbZGUMwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 08:52:50 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:40915 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbZGUMwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 08:52:47 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Felipe Balbi <me@felipebalbi.com>
Subject: [PATCH 4/4] staging: cpc-usb: add one todo entry
Date: Tue, 21 Jul 2009 15:52:26 +0300
Message-Id: <1248180746-18140-5-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1248180746-18140-4-git-send-email-me@felipebalbi.com>
References: <1248180746-18140-1-git-send-email-me@felipebalbi.com>
 <1248180746-18140-2-git-send-email-me@felipebalbi.com>
 <1248180746-18140-3-git-send-email-me@felipebalbi.com>
 <1248180746-18140-4-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we need to get rid of those driver-specific error codes

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/staging/cpc-usb/TODO |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/cpc-usb/TODO b/drivers/staging/cpc-usb/TODO
index 000e8bb..9b1752f 100644
--- a/drivers/staging/cpc-usb/TODO
+++ b/drivers/staging/cpc-usb/TODO
@@ -5,5 +5,6 @@ kernel:
 	- remove proc code
 	- tie into CAN socket interfaces if possible
 	- figure out sane userspace api
+	- use linux's error codes
 
 Send patches to Greg Kroah-Hartman <greg@kroah.com>
-- 
1.6.4.rc1

