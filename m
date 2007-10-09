Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbXJIMw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbXJIMw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 08:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbXJIMwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 08:52:49 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:34797 "EHLO
	outbound7-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722AbXJIMws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 08:52:48 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] i386: MCE updates
Date: Tue,  9 Oct 2007 14:49:54 +0200
Message-ID: <11919341961890-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
X-OriginalArrivalTime: 09 Oct 2007 12:49:57.0211 (UTC)
 FILETIME=[E572BAB0:01C80A72]
MIME-Version: 1.0
X-WSS-ID: 6B15A7731DW1286358-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes two patches. 

1. Checks for the MCA fetures as early as possible.
2. Coding style cleanup.




