Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbYIIPuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbYIIPuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYIIPt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:49:57 -0400
Received: from mx.hit.edu.cn ([202.118.224.153]:34363 "EHLO hit.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753128AbYIIPt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:49:57 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2008 11:49:55 EDT
From: Jike Song <albcamus@gmail.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]PCI: utilize calculated results when detecting MSI features
Date: Tue,  9 Sep 2008 23:42:02 +0800
Message-Id: <1220974923-5863-1-git-send-email-albcamus@gmail.com>
X-Mailer: git-send-email 1.6.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


