Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbXIWRZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbXIWRZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 13:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbXIWRZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 13:25:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:49832 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753204AbXIWRZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 13:25:33 -0400
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX1/lntALJnPlUqGkW6MlQE8lZLyrSqn/AMtsouZkZp
	1IQMegUo/WVqan
Message-ID: <46F67A3C.9070104@gmx.net>
Date: Sun, 23 Sep 2007 16:37:48 +0200
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070301 SUSE/1.0.9-1.3 SeaMonkey/1.0.9
MIME-Version: 1.0
To: linux-mtd@lists.infradead.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.23-rc7-git3: MTD cafe_nand warning
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when compiling 2.6.23-rc7-git3 with a config which resembles
allmodconfig, I get the following warning in modpost:

WARNING: Can't handle masks in drivers/mtd/nand/cafe_nand:FFFF0

Regards,
Carl-Daniel

