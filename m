Return-Path: <linux-kernel-owner+w=401wt.eu-S1761617AbXLOGsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617AbXLOGsA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 01:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXLOGrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 01:47:53 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:46950 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbXLOGrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 01:47:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to:cc:subject:content-type;
        b=nLnNGxQYciiulkO6DIxbkjlPH3CMeE5jfKEMOVRMGcjYYV0NBKGMS5EyWH7JwfJhgiR6jWnOt9qV+w44RH+6jChfgXaIaKr+y6bGew+p7Pwt6hYctlq4TWvcuDtUMrs4zRaoiLn5bv/WrENH8f1porGhKuNs08JR7tyNp8RNxpg=
Message-ID: <47637892.1000102@googlemail.com>
Date: Sat, 15 Dec 2007 07:47:46 +0100
From: Dirk Behme <dirk.behme@googlemail.com>
User-Agent: Mozilla Thunderbird 1.0.7 (X11/20050923)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: linux-omap@vger.kernel.org
Subject: [PATCH] ARM: OMAP: Change mailing list for OMAP in MAINTAINERS
Content-Type: multipart/mixed;
 boundary="------------050808090303020100060506"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050808090303020100060506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


OMAP has now a list at vger.

Signed-off-by: Dirk Behme <dirk.behme@gmail.com>


--------------050808090303020100060506
Content-Type: text/plain;
 name="maintainers_omap_ml.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="maintainers_omap_ml.txt"

Index: linux-osk/MAINTAINERS
===================================================================
--- linux-osk.orig/MAINTAINERS
+++ linux-osk/MAINTAINERS
@@ -3683,7 +3683,7 @@ S:      Maintained
 
 TI OMAP MMC INTERFACE DRIVER
 P:	Carlos Aguiar, Anderson Briglia and Syed Khasim
-M:	linux-omap-open-source@linux.omap.com (subscribers only)
+M:	linux-omap@vger.kernel.org
 W:	http://linux.omap.com
 W:	http://www.muru.com/linux/omap/
 S:	Maintained



--------------050808090303020100060506--
