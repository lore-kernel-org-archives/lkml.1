Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbXITNsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbXITNsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 09:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbXITNsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 09:48:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47853 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752835AbXITNsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 09:48:31 -0400
Date: Thu, 20 Sep 2007 14:55:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] keys: Missing word in documentation
Message-ID: <20070920145539.2341da89@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23rc6-mm1/Documentation/keys.txt linux-2.6.23rc6-mm1/Documentation/keys.txt
--- linux.vanilla-2.6.23rc6-mm1/Documentation/keys.txt	2007-09-18 15:32:50.000000000 +0100
+++ linux-2.6.23rc6-mm1/Documentation/keys.txt	2007-09-18 16:16:55.000000000 +0100
@@ -4,7 +4,7 @@
 
 This service allows cryptographic keys, authentication tokens, cross-domain
 user mappings, and similar to be cached in the kernel for the use of
-filesystems other kernel services.
+filesystems and other kernel services.
 
 Keyrings are permitted; these are a special type of key that can hold links to
 other keys. Processes each have three standard keyring subscriptions that a
