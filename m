Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbYBHNuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbYBHNuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 08:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbYBHNtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 08:49:55 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:3638 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbYBHNtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 08:49:53 -0500
From: Michael Opdenacker <michael-lists@free-electrons.com>
Organization: Free Electrons
To: randy.dunlap@oracle.com, jeff@garzik.org
Subject: [PATCH] Documentation: sysctl/kernel.txt: fix documentation reference
Date: Fri, 8 Feb 2008 14:49:26 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802081449.27060.michael-lists@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a reference to Documentation/kmod.txt
which was apparently renamed to Documentation/debugging-modules.txt

Signed-off-by: Michael Opdenacker <michael@free-electrons.com>

diff -Naur linux-2.6.24/Documentation/sysctl/kernel.txt linux-2.6.24-doc-sysctl-kernel/Documentation/sysctl/kernel.txt
--- linux-2.6.24/Documentation/sysctl/kernel.txt	2008-01-24 23:58:37.000000000 +0100
+++ linux-2.6.24-doc-sysctl-kernel/Documentation/sysctl/kernel.txt	2008-02-08 14:33:13.000000000 +0100
@@ -29,7 +29,7 @@
 - java-interpreter            [ binfmt_java, obsolete ]
 - kstack_depth_to_print       [ X86 only ]
 - l2cr                        [ PPC only ]
-- modprobe                    ==> Documentation/kmod.txt
+- modprobe                    ==> Documentation/debugging-modules.txt
 - msgmax
 - msgmnb
 - msgmni

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)
