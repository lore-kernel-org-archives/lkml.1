Return-Path: <linux-kernel-owner+w=401wt.eu-S1765914AbXHKWvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765914AbXHKWvJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 18:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763117AbXHKWuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 18:50:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:1943 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763051AbXHKWuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 18:50:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RL304RTlEFxH/y5a/PqhGJEvkMD2T7Zs6TZuXBgHYASPGHeCb7K/6s9xmonYPIk38ZkxRs1qPO31wNZidD3llDUpmeNKHhV8Y22NX80u6uB2I0dhUo4bilDaFLMzyUk1n0PCRJmTYTUguAOuVLxYpIiey9jm9USLx22N6Wsf3VU=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-doc@vger.kernel.org
Subject: [PATCH 4/5] Add a 00-INDEX file to Documentation/telephony/
Date: Sun, 12 Aug 2007 00:48:33 +0200
User-Agent: KMail/1.9.7
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux@quicknet.net, Greg Herlein <gherlein@quicknet.net>,
       Ed Okerson <eokerson@quicknet.net>, Jesper Juhl <jesper.juhl@gmail.com>
References: <200708120045.03032.jesper.juhl@gmail.com>
In-Reply-To: <200708120045.03032.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708120048.33863.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add a 00-INDEX file to Documentation/telephony/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 00-INDEX |    4 ++++
 1 file changed, 4 insertions(+)

--- /dev/null	2005-11-21 04:22:37.000000000 +0100
+++ linux-2.6/Documentation/telephony/00-INDEX	2007-08-11 23:55:54.000000000 +0200
@@ -0,0 +1,4 @@
+00-INDEX
+	- this file.
+ixj.txt
+	- document describing the Quicknet drivers.



