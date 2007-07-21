Return-Path: <linux-kernel-owner+w=401wt.eu-S932770AbXGUGAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbXGUGAu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757497AbXGUGAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:00:42 -0400
Received: from smtp2e.orange.fr ([80.12.242.113]:10033 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676AbXGUGAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:00:41 -0400
X-ME-UUID: 20070721060039265.40B6E7000088@mwinf2e16.orange.fr
From: "werner" <werner@copaya.yi.org>
Subject: Incompatibilities of kmem_cache_create 
To: linux-kernel@vger.kernel.org
X-Originating-IP: 81.248.39.47
X-Mailer: Usermin 1.270
Message-Id: <1184997001.28478@werner>
Date: Sat, 21 Jul 2007 02:50:01 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1184997001"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1184997001
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

Of the kernel 2.6.22-git15 of this night,  kmem_cache_create is not compatible and causes compiling errors of some fundamental programs.  Before, this error didnt occur.

At least this happened on compiling the externel modules for btrfs and ndiskwrapper.    Principally the compatibility of the Kernel with older and new versions of the file systems have to be observed very good, for the reliability to can read dates.

Thus this should be checked, and corrected

Werner Landgraf

werner@copaya.yi.org

www.copaya.yi.org

--bound1184997001--


