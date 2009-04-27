Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZD0UZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZD0UZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbZD0UZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:25:50 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:49738 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbZD0UZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:25:49 -0400
To: linux-kernel@vger.kernel.org
Subject: e100.txt blooper
From: jidanni@jidanni.org
Date: Tue, 28 Apr 2009 04:24:39 +0800
Message-ID: <87k555kfp4.fsf@jidanni.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think I discovered a blooper. If so please apply this diff.

--- /usr/share/doc/linux-doc-2.6.29/Documentation/networking/e100.txt 2009-04-28 03:10:32.809522639 +0800
+++ -	2009-04-28 03:10:32.815155759 +0800
@@ -114,7 +114,7 @@
   console, you must set the dmesg level up to six. This can be done by
   entering the following on the command line before loading the e100 driver:
 
-       dmesg -n 8
+       dmesg -n 6
 
   If you wish to see all messages issued by the driver, including debug
   messages, set the dmesg level to eight.
