Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbXEMTPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbXEMTPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbXEMTPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:15:41 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:46915 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760182AbXEMTPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:15:40 -0400
From: muli@il.ibm.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: OSS trident updates
Date: Sun, 13 May 2007 22:15:25 +0300
Message-Id: <11790837281608-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.4.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

Please push these trident patches to Linus. Three patches, one
whitespace, one fixes a race found by inspection and one replaces
pci_find_device with pci_get_device.

Thanks,
Muli
