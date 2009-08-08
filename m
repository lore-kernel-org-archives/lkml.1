Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZHHGtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZHHGtb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 02:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZHHGta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 02:49:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:63010 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbZHHGta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 02:49:30 -0400
Date: Fri, 7 Aug 2009 23:49:20 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: nhorman@tuxdriver.com
Subject: [PATCH] typo in crypto/rng.c
Message-ID: <alpine.DEB.2.01.0908072346000.5831@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX192v86YJvrI8pSZ9nZe/hXw/Tw+jFhn5X482WG
 +KyMLDLUmUJhWZyVMrITet08eBuJ300GdTx1rbyvmLwcUztw/W
 yZBzgpq45GgFQhYgWw+Eg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Correct a typo in crypto/rng.c

Signed-off-by: Christian Kujau <lists@nerdbynature.de>

--- linux-2.6-git/crypto/rng.c.orig	2009-08-08 08:43:49.227693375 +0200
+++ linux-2.6-git/crypto/rng.c	2009-08-08 08:44:54.735426448 +0200
@@ -123,4 +123,4 @@ void crypto_put_default_rng(void)
 EXPORT_SYMBOL_GPL(crypto_put_default_rng);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Random Number Genertor");
+MODULE_DESCRIPTION("Random Number Generator");

-- 
BOFH excuse #229:

wrong polarity of neutron flow
