Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbXICIVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbXICIVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbXICIT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:19:57 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:31816 "EHLO
	outbound10-sin-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754932AbXICITy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:19:54 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Message-ID: <20070903081736.288288000@amd.com>
User-Agent: quilt/0.46-1
Date: Mon, 03 Sep 2007 10:17:36 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: patches@x86-64.org, linux-kernel@vger.kernel.org,
       "Robert Richter" <robert.richter@amd.com>
Subject: [patch 0/5] (resent) x86: PCI extended config space access on
 AMD Barcelona CPUs
X-OriginalArrivalTime: 03 Sep 2007 08:18:31.0574 (UTC)
 FILETIME=[0394BB60:01C7EE03]
MIME-Version: 1.0
X-WSS-ID: 6AC51C121A46452967-10-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(resent due to mail server issues)

Hello,

the following series of patches adds support for PCI extended
configuration space access of AMD's Barcelona CPUs (family 10h). It
modifies the CF8/CFC IO register access method and sets the size of
the CPU's PCI devices to 4096 bytes.

Regards,
Robert

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com



