Return-Path: <linux-kernel-owner+w=401wt.eu-S1761194AbXGTD0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761194AbXGTD0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbXGTD0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:26:47 -0400
Received: from smtp23.orange.fr ([193.252.22.30]:9038 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbXGTD0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:26:47 -0400
X-ME-UUID: 20070720032644119.1D4131C00087@mwinf2334.orange.fr
From: "werner" <werner@copaya.yi.org>
Subject: Kernel Error / Crash
To: linux-kernel@vger.kernel.org
X-Originating-IP: 81.248.33.170
X-Mailer: Usermin 1.270
Message-Id: <1184901372.4269@werner>
Date: Fri, 20 Jul 2007 00:16:12 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1184901372"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1184901372
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

To: linux-kernel@vger.kernel.org


copied from the screen:

...
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
Starting udevd: /sbin/udevd -- daemon
------------[cut here]-------------------
Kernel BUG at mm/slub.c:2401!
Invalid opcode: 0000[#1]
SMP
Modules linked in:
CPU: 0
EIP: 0060: [<c0174ec0>]   Not tainted VLI
EFLAGS:  00010046  (2.6.22-git13-i486-1mn #1)
EIP is at ksize + 0x40/0x50
  .....

Obs:  With 2.6.22-git11 that problem didnt occur

Werner Landgraf
werner@copaya.yi.org


--bound1184901372--


