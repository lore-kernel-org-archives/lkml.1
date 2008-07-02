Return-Path: <linux-kernel-owner+w=401wt.eu-S1760102AbYGBWF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102AbYGBWF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 18:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbYGBWFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 18:05:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:43402 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754693AbYGBWFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 18:05:16 -0400
X-Authenticated: #24798553
X-Provags-ID: V01U2FsdGVkX1/WSYlfDGfWgd/pkrB/pJaOQZHaX6gn6SUOUJebYv
	pqIxyGZfrkbhgK
Message-ID: <486BFB7E.3040506@gmx.eu>
Date: Thu, 03 Jul 2008 00:04:46 +0200
From: Mijo Safradin <mijo@gmx.eu>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, trivial@kernel.org, gregkh@suse.de
Subject: [PATCH] Documentation: fix spelling in kobject.txt
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


trivial change: fix spelling

Signed-off-by: Mijo Safradin <mijo@gmx.eu>

Index: linux-2.6/Documentation/kobject.txt
===================================================================
--- linux-2.6.orig/Documentation/kobject.txt    2008-07-03 00:02:28.000000000 +0200
+++ linux-2.6/Documentation/kobject.txt 2008-07-03 00:02:35.000000000 +0200
@@ -383,4 +383,4 @@
  Example code to copy from

  For a more complete example of using ksets and kobjects properly, see the
-sample/kobject/kset-example.c code.
+samples/kobject/kset-example.c code.

