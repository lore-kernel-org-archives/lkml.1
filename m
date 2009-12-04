Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZLDBLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZLDBLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 20:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbZLDBLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 20:11:12 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:38633 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZLDBLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 20:11:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pLffmFxaBoxi2qZjdKt09b0SaDNLqWZzVnJglvKF3+jQUY2UkaSUTMx1f7X9k28jag
         TrVquVlVF6OfVqVnzFVxhORj6EGuypqX4bmYr8n5DvpqejiHX6ChKlyd7IGUzVeL0zHO
         +yGvtCeEnJusmoNCYHOkaRcCJzx2TZyPmZwjM=
MIME-Version: 1.0
Date: Thu, 3 Dec 2009 20:11:17 -0500
Message-ID: <a8cdcc00912031711y3f5f182cy79a1067afb6a8d6a@mail.gmail.com>
Subject: [PATCH] Spelling in in /arch/x86/mm
From: Shaun Patterson <shaunpatterson@gmail.com>
To: pq@iki.fi
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fix
Signed-off-by: Shaun Patterson shaunpatterson@gmail.com
---
 arch/x86/mm/kmmio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 16ccbd7..72f1572 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -490,7 +490,7 @@ static void remove_kmmio_fault_pages(struct rcu_head *head)
  * 2. remove_kmmio_fault_pages()
  *    Remove the pages from kmmio_page_table.
  * 3. rcu_free_kmmio_fault_pages()
- *    Actally free the kmmio_fault_page structs as with RCU.
+ *    Actually free the kmmio_fault_page structs as with RCU.
  */
 void unregister_kmmio_probe(struct kmmio_probe *p)
 {
