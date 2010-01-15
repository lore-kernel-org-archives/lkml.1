Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034Ab0AOAwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab0AOAwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210Ab0AOAwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:52:44 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:50916 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab0AOAwn (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 14 Jan 2010 19:52:43 -0500
From: Konrad Rzeszutek Wilk <ketuzsezr@darnok.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, michaelc@cs.wisc.edu,
       pjones@redhat.com, James.Bottomley@HansenPartnership.com,
       akpm@linux-foundation.org
Subject: [GIT PULL] iSCI iBFT updates for 2.6.33-rc4
Date: Thu, 14 Jan 2010 19:47:29 -0500
Message-Id: <1263516450-18720-1-git-send-email-ketuzsezr@darnok.org>
X-Mailer: git-send-email 1.6.2.5
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B4FBC37.00AD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the 'ibft-fixes' branch from:

	git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git ibft-fixes

This contains a small improvement to the driver.

Joe Perches <joe@perches.com>:
	[PATCH] drivers/firmware/iscsi_ibft.c: remove NIPQUAD_FMT, use %pI4

 drivers/firmware/iscsi_ibft.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

