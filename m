Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbYDSNnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbYDSNnp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 09:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbYDSNnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 09:43:35 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:43672 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYDSNne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 09:43:34 -0400
X-Greylist: delayed 845 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Apr 2008 09:43:34 EDT
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200804191329.m3JDTS0m023459@clem.clem-digital.net>
Subject: 2.6.25-git2 fails build (nf_nat_proto_sctp.ko)
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Sat, 19 Apr 2008 09:29:28 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi:


Root device is (3, 1)
Setup is 11288 bytes (padded to 11776 bytes).
System is 1162 kB
CRC 695701be
Kernel: arch/x86/boot/bzImage is ready  (#4)
  Building modules, stage 2.
  MODPOST 132 modules
ERROR: "crc32c_le" [net/ipv4/netfilter/nf_nat_proto_sctp.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

-- 
Pete Clements 
