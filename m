Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbZBAWcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbZBAWcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 17:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZBAWcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 17:32:07 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:54616 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbZBAWcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 17:32:07 -0500
Message-ID: <498622DA.9080106@freemail.hu>
Date: Sun, 01 Feb 2009 23:31:54 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>
Subject: [PATCH] DAB: fix typo
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32710; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Fix typo in "DAB adapters" section in Kconfig.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.29-rc3/drivers/media/Kconfig.orig	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.29-rc3/drivers/media/Kconfig	2009-02-01 13:30:54.000000000 +0100
@@ -117,7 +117,7 @@ source "drivers/media/dvb/Kconfig"
 config DAB
 	boolean "DAB adapters"
 	---help---
-	  Allow selecting support for for Digital Audio Broadcasting (DAB)
+	  Allow selecting support for Digital Audio Broadcasting (DAB)
 	  Receiver adapters.

 if DAB
