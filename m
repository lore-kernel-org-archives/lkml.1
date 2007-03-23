Return-Path: <linux-kernel-owner+w=401wt.eu-S1945918AbXCWPme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945918AbXCWPme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 11:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992464AbXCWPme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 11:42:34 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60718 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945918AbXCWPmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 11:42:33 -0400
X-Originating-Ip: 74.109.98.130
Date: Fri, 23 Mar 2007 11:32:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH] DVB:  Delete unused header file linux/dvb/version.h.
Message-ID: <Pine.LNX.4.64.0703231130480.30201@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Delete the unreferenced header file include/linux/dvb/version.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/include/linux/dvb/version.h b/include/linux/dvb/version.h
deleted file mode 100644
index 6183c9c..0000000
--- a/include/linux/dvb/version.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * version.h
- *
- * Copyright (C) 2000 Holger Waechtler <holger@convergence.de>
- *                    for convergence integrated media GmbH
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public License
- * as published by the Free Software Foundation; either version 2.1
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- *
- */
-
-#ifndef _DVBVERSION_H_
-#define _DVBVERSION_H_
-
-#define DVB_API_VERSION 3
-#define DVB_API_VERSION_MINOR 1
-
-#endif /*_DVBVERSION_H_*/
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
