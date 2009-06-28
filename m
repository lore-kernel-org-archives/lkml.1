Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbZF1Sf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbZF1Sf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 14:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZF1SfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 14:35:18 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1583 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZF1SfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 14:35:17 -0400
Subject: [PATCH] MAINTAINERS: QLGE 10Gb ETHERNET - pair P:/M: entries
 properly
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ron Mercer <ron.mercer@qlogic.com>, linux-driver@qlogic.com,
       netdev@vger.kernel.org
In-Reply-To: <86a775a4ef18051cbf116f969e07d8cb36e56b10.1246173681.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
	 <86a775a4ef18051cbf116f969e07d8cb36e56b10.1246173681.git.joe@perches.com>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 11:35:19 -0700
Message-Id: <1246214119.13673.19.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fa2a16d..57357d4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4766,8 +4766,8 @@ F:	drivers/net/qla3xxx.*
 
 QLOGIC QLGE 10Gb ETHERNET DRIVER
 P:	Ron Mercer
-M:	linux-driver@qlogic.com
 M:	ron.mercer@qlogic.com
+M:	linux-driver@qlogic.com
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/qlge/


