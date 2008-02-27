Return-Path: <linux-kernel-owner+w=401wt.eu-S1765674AbYB0DUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765674AbYB0DUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 22:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbYB0DTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 22:19:55 -0500
Received: from smtp-out.google.com ([216.239.45.13]:33453 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbYB0DTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 22:19:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:content-type:content-transfer-encoding;
	b=hJvDrzisQdVLSNJG3zncAShinzX36ZHYBaEIUjKCL5XjJcDrHYI+c+5q25ERbowwx
	eSMCU+OzpmAx6b8YGPdLw==
Message-ID: <47C4D6C0.6080405@google.com>
Date: Tue, 26 Feb 2008 19:19:28 -0800
From: Paul Menage <menage@google.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH] Control Groups: Add Paul Menage a maintainer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Control Groups: Add Paul Menage as maintainer

Signed-off-by: Paul Menage <menage@google.com>

---
 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

Index: maintainers-2.6.25-rc3/MAINTAINERS
===================================================================
--- maintainers-2.6.25-rc3.orig/MAINTAINERS
+++ maintainers-2.6.25-rc3/MAINTAINERS
@@ -1132,6 +1132,12 @@ L:	accessrunner-general@lists.sourceforg
 W:	http://accessrunner.sourceforge.net/
 S:	Maintained
 
+CONTROL GROUPS (CGROUPS)
+P:	Paul Menage
+M:	menage@google.com
+L:	containers@lists.linux-foundation.org
+S:	Maintained
+
 CORETEMP HARDWARE MONITORING DRIVER
 P:	Rudolf Marek
 M:	r.marek@assembler.cz
