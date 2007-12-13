Return-Path: <linux-kernel-owner+w=401wt.eu-S1761157AbXLMHsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761157AbXLMHsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbXLMHs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 02:48:29 -0500
Received: from de01egw01.freescale.net ([192.88.165.102]:60416 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbXLMHs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 02:48:28 -0500
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, paulus@samba.org, galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       wei.zhang@freescale.com
Subject: [0/3] Add RapidIO support to powerpc architecture with memory mapping
Date: Thu, 13 Dec 2007 15:58:15 +0800
Message-Id: <11975326982876-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.2
X-OriginalArrivalTime: 13 Dec 2007 07:48:22.0811 (UTC) FILETIME=[893226B0:01C83D5C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Those patches add RapidIO support to powerpc archiecture with
memory mapping as below:

[1/3] Copy the arch/ppc RapidIO support to arch/powerpc
[2/3] Make the arch/powerpc RapidIO support workable with of-device
      and add memory mapping support.
[3/3] Add the memory mapping support to rionet driver.

Best Regards,
Zhang Wei


