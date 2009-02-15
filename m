Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbZBOMd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbZBOMd5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 07:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbZBOMds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 07:33:48 -0500
Received: from cantor.suse.de ([195.135.220.2]:38351 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbZBOMds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:33:48 -0500
Message-ID: <49980A67.7030403@suse.de>
Date: Sun, 15 Feb 2009 13:28:23 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>, rlove@rlove.org,
       Frank Seidel <fseidel@suse.de>, Frank Seidel <frank@f-seidel.de>
Subject: [PATCH] MAINTAINERS: switch hdaps to Frank Seidel
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

As Rovert Love doesn't any more seem to be realy
active on hdaps driver i'll happily take it over.

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1905,10 +1905,10 @@ W:	http://gigaset307x.sourceforge.net/
 S:	Maintained
 
 HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
-P:	Robert Love
-M:	rlove@rlove.org
+P:	Frank Seidel
+M:	frank@f-seidel.de
 M:	linux-kernel@vger.kernel.org
-W:	http://www.kernel.org/pub/linux/kernel/people/rml/hdaps/
+W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/
 S:	Maintained
 
 GSPCA FINEPIX SUBDRIVER
