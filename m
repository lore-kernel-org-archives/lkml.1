Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYLKQss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYLKQss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755779AbYLKQsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:48:37 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:43176 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbYLKQsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:48:36 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KBQ1CL-01-7NW-01
From: Robert Richter <robert.richter@amd.com>
To: oprofile-list <oprofile-list@lists.sourceforge.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/10] oprofile and ftrace: some trivial patches
Date: Thu, 11 Dec 2008 16:04:36 +0100
Message-ID: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
X-OriginalArrivalTime: 11 Dec 2008 16:48:26.0761 (UTC) FILETIME=[49D18790:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch set contains some cleanups, code reworks and fixes
for oprofile. Additional there are 2 trivial patches for ftrace
too. This patch set is in preparation of a follow on patch set that
ports to the new ring buffer.

Patches are also here:

git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git next

-Robert



