Return-Path: <linux-kernel-owner+w=401wt.eu-S1762858AbXGJLfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762858AbXGJLfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 07:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbXGJLfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 07:35:14 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:35127 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbXGJLfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 07:35:12 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix typo in include/linux/pci.h
Date: Tue, 10 Jul 2007 13:35:05 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org,
       Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707101335.05637.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

---
commit f57463dabf991c306dc43dcf7445ec574484e4ee
tree 37c5d48baf200d7c8d04e506fd8b992179511113
parent 58056c2424917e90b86ca11c2c5d3fd35313d7b6
author Rolf Eike Beer <eike-kernel@sf-tec.de> Tue, 10 Jul 2007 13:32:29 +0200
committer Rolf Eike Beer <eike-kernel@sf-tec.de> Tue, 10 Jul 2007 13:32:29 +0200

 include/linux/pci.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 086a0e5..87aa73e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -313,7 +313,7 @@ struct pci_dynids {
 
 /* ---------------------------------------------------------------- */
 /** PCI Error Recovery System (PCI-ERS).  If a PCI device driver provides
- *  a set fof callbacks in struct pci_error_handlers, then that device driver
+ *  a set of callbacks in struct pci_error_handlers, then that device driver
  *  will be notified of PCI bus errors, and will be driven to recovery
  *  when an error occurs.
  */
