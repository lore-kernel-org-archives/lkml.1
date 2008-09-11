Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYIKDSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYIKDSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 23:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYIKDR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 23:17:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:37586 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbYIKDR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 23:17:58 -0400
From: Kevin Hao <kexin.hao@windriver.com>
To: ak@linux.intel.com, astarikovskiy@suse.de, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: [PATCH 0/2]linux-next: fix two bugs in ACPI EC driver
Date: Thu, 11 Sep 2008 11:17:43 +0800
Message-Id: <1221103065-9123-1-git-send-email-kexin.hao@windriver.com>
X-Mailer: git-send-email 1.5.6.2.220.g44701
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

These patches fix two bugs in ACPI EC driver.
First one fix ec read and write data bug.
Second one fix ec EC_FLAGS_GPE_STORM flag always set bug.

Thanks,
Kevin


