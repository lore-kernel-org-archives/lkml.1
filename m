Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbYJTQcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbYJTQcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYJTQbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:31:55 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:61305 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbYJTQby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:31:54 -0400
X-BigFish: VPS-10(z5edJz62a3L4015Mzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K91PWO-01-16V-01
Date: Mon, 20 Oct 2008 18:31:24 +0200
From: Robert Richter <robert.richter@amd.com>
To: oprofile-list <oprofile-list@lists.sourceforge.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: OProfile kernel tree update
Message-ID: <20081020163123.GD1029@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Oct 2008 16:31:40.0693 (UTC) FILETIME=[54ACBC50:01C932D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the last days I have added the following cleanup and fixes to the
OProfile kernel tree:

Barry Kasindorf (1):
      OProfile: Fix buffer synchronization for IBS

Chris J Arges (1):
      oprofile: hotplug cpu fix

Robert Richter (2):
      oprofile: fixing whitespaces in drivers/oprofile/*
      oprofile: fixing whitespaces in arch/x86/oprofile/*

These patches will go upstream for v2.6.28. Please test the next
branch on:

git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git

If you miss your oprofile patch for .28 in next, let me know.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

