Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbYG2B5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbYG2B5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYG2B5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:57:02 -0400
Received: from [61.183.207.101] ([61.183.207.101]:24130 "EHLO
	mail.fiberhome.com.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbYG2B5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:57:01 -0400
X-Greylist: delayed 3955 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jul 2008 21:57:00 EDT
Date: Tue, 29 Jul 2008 08:45:31 +0800
From: "cyx" <cyx@fiberhome.com.cn>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: help, multicast routing not work.
Message-ID: <200807290845312961772@fiberhome.com.cn>
X-mailer: Foxmail 6, 13, 102, 15 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jul 2008 00:41:07.0475 (UTC) FILETIME=[C9F10E30:01C8F113]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,all
    I don't know it is the right place to post this question:)
	I got igmpproxy runs on a Linux box which has eth0 and eth1, 2 VIFs. eth0 to wan and eth1 to lan.But I can't play the multicast media stream that comes from eth0.
	I have checked /proc/net/ip_mr_vif & /proc/net/ip_mr_cache and seems igmpproxy have done the right configuration about multicast routing in the kernel. All config are OK but muticast udp data can't forward. Any ideas? I'm exhausted to make all things right, help me! 

