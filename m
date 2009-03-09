Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbZCIJVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbZCIJVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 05:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZCIJVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 05:21:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:45470 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbZCIJVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 05:21:06 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [v1 PATCH 0/1] PCI: Add PCI Device ID for the PCI Bridge Controller on AMD8111 chip
Date: Mon,  9 Mar 2009 17:09:02 +0800
Message-Id: <1236589743-4358-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 09 Mar 2009 09:21:02.0210 (UTC) FILETIME=[5D921E20:01C9A098]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Comments:
---------
Add the PCI Device ID for the PCI Bridge Controller on AMD8111 chip,
which is used by AMD8111 EDAC driver.

Test:
-----
This patch has been tested along with the series of patches of
"[v1 PATCH 0/8] Add AMD8111 and AMD8131 EDAC drivers", the PCI Bridge
Controller on AMD8111 chip could be successfully probed.

Diffstat:
---------
0001-PCI-Add-AMD8111-PCI-Bridge-PCI-Device-ID.patch
 include/linux/pci_ids.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
