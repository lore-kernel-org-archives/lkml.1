Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbZGGOjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbZGGOjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758855AbZGGOhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:37:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:43377 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758439AbZGGOhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:37:22 -0400
Subject: [PATCH 22/22] trivial: fix typo "you you"
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:56:59 +0530
Message-Id: <1246976819.3613.39.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "you you" with "you"

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 Documentation/DocBook/uio-howto.tmpl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index 8f6e3b2..a55491c 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -511,7 +511,7 @@ Here's a description of the fields of <varname>struct uio_mem</varname>:
 <itemizedlist>
 <listitem><para>
 <varname>int memtype</varname>: Required if the mapping is used. Set this to
-<varname>UIO_MEM_PHYS</varname> if you you have physical memory on your
+<varname>UIO_MEM_PHYS</varname> if you have physical memory on your
 card to be mapped. Use <varname>UIO_MEM_LOGICAL</varname> for logical
 memory (e.g. allocated with <function>kmalloc()</function>). There's also
 <varname>UIO_MEM_VIRTUAL</varname> for virtual memory.
-- 
1.6.0.6



