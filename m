Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbYESWSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbYESWSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765614AbYESWLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:11:49 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43217 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765356AbYESWLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:11:47 -0400
Date: Tue, 20 May 2008 01:09:42 +0300
From: Adrian Bunk <bunk@kernel.org>
To: bzolnier@gmail.com, Lionel.Bouton@inet6.fr
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] MAINTAINERS: remove SIS 5513 IDE entry
Message-ID: <20080519220942.GX17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- maintainer has not been active for years
- URLs no longer exist
- covered by the IDE SUBSYSTEM entry

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
277a244cfa665db347cc0c2ec27b19d73fd0ee2a diff --git a/MAINTAINERS b/MAINTAINERS
index af69cab..0220ce9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3623,13 +3623,6 @@ M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 
-SIS 5513 IDE CONTROLLER DRIVER
-P:	Lionel Bouton
-M:	Lionel.Bouton@inet6.fr
-W:	http://inet6.dyn.dhs.org/sponsoring/sis5513/index.html
-W:	http://gyver.homeip.net/sis5513/index.html
-S:	Maintained
-
 SIS 900/7016 FAST ETHERNET DRIVER
 P:	Daniele Venzano
 M:	venza@brownhat.org

