Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbXKNNfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbXKNNfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 08:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbXKNNfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 08:35:09 -0500
Received: from mail12.tpgi.com.au ([203.12.160.162]:48744 "EHLO
	mail12.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbXKNNfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 08:35:08 -0500
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Nov 2007 08:35:08 EST
X-TPG-Antivirus: Passed
Subject: 2.6.24-rc2 panic: (non-exitent) NFS root f/s
From: Shane <ibm-main@tpg.com.au>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 14 Nov 2007 23:19:53 +1000
Message-Id: <1195046393.9513.19.camel@toshi>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

New guy to this list. Long time lurker on CKRM - decided to test the
control groups patches.
Pulled 2.6.24.rc4 patch and migrated my (working) 2.6.23-rc4 config.

Panic'd because of NFS root not found - not too surprising as I don't
have one.
Any ideas why this option comes up selected ???. Same result if I "make
oldconfig" or "make menuconfig" (after "make mrproper" in both cases).
Maybe some weird combination of containers/cpusets/??? ...

What should I be looking for to troubleshoot ???.

