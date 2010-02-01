Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0BASBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:01:35 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:38711 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab0BASBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:01:32 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: [PATCH] doc: console doc should read "bind & unbind" instead of "bind & bind"
Date: Mon,  1 Feb 2010 15:57:15 -0200
Message-Id: <1265047036-7402-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 Documentation/console/console.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/console/console.txt b/Documentation/console/console.txt
index 877a1b2..926cf1b 100644
--- a/Documentation/console/console.txt
+++ b/Documentation/console/console.txt
@@ -74,7 +74,7 @@ driver takes over the consoles vacated by the driver. Binding, on the other
 hand, will bind the driver to the consoles that are currently occupied by a
 system driver.
 
-NOTE1: Binding and binding must be selected in Kconfig. It's under:
+NOTE1: Binding and unbinding must be selected in Kconfig. It's under:
 
 Device Drivers -> Character devices -> Support for binding and unbinding
 console drivers
-- 
1.6.6.1

