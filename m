Return-Path: <linux-kernel-owner+w=401wt.eu-S1765314AbXHKWtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765314AbXHKWtc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 18:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762771AbXHKWtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 18:49:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:4526 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762390AbXHKWtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 18:49:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Q3F9T2oAMNDlHI6cMrBw8jAc2lkfQ7DfFjvN6G6yV2solyfRLH9oMQp7BpXln97ORaP6x+nMNb/6pWW8kwl2Vlv1C1K6CwjbKg/bwBt81vR9AmbVfsYHJ+zet51L6jJXTCISJGwsWEmHyknT75zYRByJL3BbnR1cKJ8XTlwfkIY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-doc@vger.kernel.org
Subject: [PATCH 2/5] Add a 00-INDEX file to Documentation/mips/
Date: Sun, 12 Aug 2007 00:47:02 +0200
User-Agent: KMail/1.9.7
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>, Jesper Juhl <jesper.juhl@gmail.com>
References: <200708120045.03032.jesper.juhl@gmail.com>
In-Reply-To: <200708120045.03032.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708120047.02750.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add a 00-INDEX file to Documentation/mips/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 00-INDEX |    8 ++++++++
 1 file changed, 8 insertions(+)

--- /dev/null	2005-11-21 04:22:37.000000000 +0100
+++ linux-2.6/Documentation/mips/00-INDEX	2007-08-11 22:56:26.000000000 +0200
@@ -0,0 +1,8 @@
+00-INDEX
+	- this file.
+AU1xxx_IDE.README
+	- README for MIPS AU1XXX IDE driver.
+GT64120.README
+	- README for dir with info on MIPS boards using GT-64120 or GT-64120A.
+time.README
+	- README for MIPS time services.



