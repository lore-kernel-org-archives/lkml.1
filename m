Return-Path: <linux-kernel-owner+w=401wt.eu-S1946465AbXBCPFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946465AbXBCPFw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 10:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946467AbXBCPFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 10:05:52 -0500
Received: from 263.net.cn ([211.150.96.21]:42820 "EHLO smtp.263.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946465AbXBCPFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 10:05:51 -0500
X-KSVirus-check: 0
X-ABS-CHECKED: 0
X-SENDER-IP: 221.201.75.142
X-LOGIN-NAME: linux
Subject: Some process went UNINTERRUPTABLE forever.
From: "Di, Wu" <linux@51sun.cn>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 03 Feb 2007 15:06:31 +0000
Message-Id: <1170515191.3655.10.camel@linux-soc5.51sun.cn>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The process status of 'pdflush' went to UNINTERRUPTIBLE forever, and
then I edit some file(in other media) use 'vi', the 'vi' also went to
that status. And I cannot even reboot my system, instead I need use the
power button.
I am using Kernel-2.6.20-rc6-mm3 with 'preemptible' option.


