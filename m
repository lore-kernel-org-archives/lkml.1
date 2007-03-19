Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbXCSHdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbXCSHdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 03:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbXCSHdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 03:33:35 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:42968 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752277AbXCSHde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 03:33:34 -0400
Message-ID: <45FE38C3.1010201@freemail.hu>
Date: Mon, 19 Mar 2007 08:16:19 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; hu-HU; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Trivial Patch Monkey <trivial@kernel.org>
Subject: [PATCH] platform: small typo in doc
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Typo: iwithout -> without.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---

--- linux-2.6.21-rc4.orig/drivers/base/platform.c	2007-03-16 01:20:01.000000000 +0100
+++ linux-2.6.21-rc4/drivers/base/platform.c	2007-03-19 08:08:33.000000000 +0100
@@ -347,7 +347,7 @@ EXPORT_SYMBOL_GPL(platform_device_unregi
   *	This function creates a simple platform device that requires minimal
   *	resource and memory management. Canned release function freeing
   *	memory allocated for the device allows drivers using such devices
- *	to be unloaded iwithout waiting for the last reference to the device
+ *	to be unloaded without waiting for the last reference to the device
   *	to be dropped.
   */
  struct platform_device *platform_device_register_simple(char *name, unsigned int id,
