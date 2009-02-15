Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbZBOOIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbZBOOIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 09:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZBOOIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 09:08:13 -0500
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:48710 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768AbZBOOIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 09:08:12 -0500
Message-ID: <49982084.80609@f-seidel.de>
Date: Sun, 15 Feb 2009 15:02:44 +0100
From: Frank Seidel <frank@f-seidel.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Frank Seidel <fseidel@suse.de>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, rlove@rlove.org,
       Frank Seidel <frank@f-seidel.de>, lm-sensors@lm-sensors.org
Subject: [PATCHv2] MAINTAINERS: switch hdaps to Frank Seidel
References: <49980A67.7030403@suse.de>
In-Reply-To: <49980A67.7030403@suse.de>
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
 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1905,10 +1905,10 @@ W:	http://gigaset307x.sourceforge.net/
 S:	Maintained
 
 HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
-P:	Robert Love
-M:	rlove@rlove.org
-M:	linux-kernel@vger.kernel.org
-W:	http://www.kernel.org/pub/linux/kernel/people/rml/hdaps/
+P:	Frank Seidel
+M:	frank@f-seidel.de
+M:	lm-sensors@lm-sensors.org
+W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/hdaps
 S:	Maintained
 
 GSPCA FINEPIX SUBDRIVER

