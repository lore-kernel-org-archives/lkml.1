Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbXJXKvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbXJXKvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 06:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbXJXKuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 06:50:17 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:31368 "EHLO
	mail63-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186AbXJXKuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 06:50:09 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>
Subject: [PATCH 0/4] x86: some GART cleanups
Date: Wed, 24 Oct 2007 12:49:46 +0200
Message-ID: <11932229902276-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11932229902428-git-send-email-joerg.roedel@amd.com>
References: <11932229902428-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Oct 2007 10:49:50.0868 (UTC)
 FILETIME=[9A544D40:01C8162B]
MIME-Version: 1.0
X-WSS-ID: 6B01FCDB0QK73690-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



