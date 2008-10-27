Return-Path: <linux-kernel-owner+w=401wt.eu-S1752136AbYJ0PK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbYJ0PK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbYJ0PKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:10:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58264 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751591AbYJ0PKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:10:20 -0400
Date: Mon, 27 Oct 2008 15:10:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Tidy up addresses in random drivers
Message-ID: <20081027151023.1ae69b73@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index c422e87..cd0ba51 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -11,7 +11,7 @@
  * derived from
  *
  * Hardware driver for the AMD 768 Random Number Generator (RNG)
- * (c) Copyright 2001 Red Hat Inc <alan@redhat.com>
+ * (c) Copyright 2001 Red Hat Inc
  *
  * derived from
  *
diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
index fed4ef5..64d513f 100644
--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -11,7 +11,7 @@
  * derived from
  *
  * Hardware driver for the AMD 768 Random Number Generator (RNG)
- * (c) Copyright 2001 Red Hat Inc <alan@redhat.com>
+ * (c) Copyright 2001 Red Hat Inc
  *
  * derived from
  *
diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 8a2fce0..5dcbe60 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -11,7 +11,7 @@
  * derived from
  *
  * Hardware driver for the AMD 768 Random Number Generator (RNG)
- * (c) Copyright 2001 Red Hat Inc <alan@redhat.com>
+ * (c) Copyright 2001 Red Hat Inc
  *
  * derived from
  *
diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index 128202e..4e9573c 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -11,7 +11,7 @@
  * derived from
  *
  * Hardware driver for the AMD 768 Random Number Generator (RNG)
- * (c) Copyright 2001 Red Hat Inc <alan@redhat.com>
+ * (c) Copyright 2001 Red Hat Inc
  *
  * derived from
  *
