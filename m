Return-Path: <linux-kernel-owner+w=401wt.eu-S966089AbXG3C7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966089AbXG3C7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 22:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbXG3C6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 22:58:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39089 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbXG3C6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 22:58:55 -0400
Date: Mon, 30 Jul 2007 08:41:12 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Howells <dhowells@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][resend] Fix a typo in Documentation/keys.txt
Message-ID: <alpine.LFD.0.999.0707300836370.10861@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] Fix a typo in Documentation/keys.txt

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: David Howells <dhowells@redhat.com>

---

[ Previously sent on: June 9, 2007 ]

 Documentation/keys.txt |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -ruNp a/Documentation/keys.txt b/Documentation/keys.txt
--- a/Documentation/keys.txt	2007-06-03 02:33:02.000000000 +0530
+++ b/Documentation/keys.txt	2007-06-03 02:38:52.000000000 +0530
@@ -859,9 +859,8 @@ payload contents" for more information.
 	void unregister_key_type(struct key_type *type);
 
 
-Under some circumstances, it may be desirable to desirable to deal with a
-bundle of keys.  The facility provides access to the keyring type for managing
-such a bundle:
+Under some circumstances, it may be desirable to deal with a bundle of keys.
+The facility provides access to the keyring type for managing such a bundle:
 
 	struct key_type key_type_keyring;
 
