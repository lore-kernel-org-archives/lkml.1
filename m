Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbYCLVo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbYCLVo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbYCLVns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:43:48 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:61691 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576AbYCLVnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:43:47 -0400
From: York Sun <yorksun@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, galak@kernel.crashing.org
Subject: Driver for Freescale Display Interface Unit (A LCD controller)
Date: Wed, 12 Mar 2008 16:43:41 -0500
Message-Id: <12053582234100-git-send-email-yorksun@freescale.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patches are for Freescale DIU. The first patch is a DIU driver.
The second patch is the platform code to support the driver. It is a frame
buffer driver for DIU. Descriptions can be found in the patches.

It is a new feature targeting 2.6.26 kernel.

