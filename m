Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbYG2Aqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbYG2Aqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYG2Aqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:46:43 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:47227 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbYG2Aqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=tly0BFSyhPMDgtWj9sVmSt+bolGBIm2JYGGe7XLVfrcR4pRvgjaltnnYgsXdCpiPjF
         lELBF1Y54VPzcu8Cn7cV5gK6sjbJpO5GCUQ2rPK1rIyGvgygt38cxQGrpM74gs5vA3K4
         yfR3oVb42C50RYzYGu3JXMBaijSq+GQFErLB0=
Date: Tue, 29 Jul 2008 08:46:30 +0800
From: "c4linux" <c4linux@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: help, multicast routing not work.
Message-ID: <200807290846287506992@gmail.com>
X-mailer: Foxmail 6, 13, 102, 15 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,all
    I don't know it is the right place to post this question:)
	I got igmpproxy runs on a Linux box which has eth0 and eth1, 2 VIFs. eth0 to wan and eth1 to lan.But I can't play the multicast media stream that comes from eth0.
	I have checked /proc/net/ip_mr_vif & /proc/net/ip_mr_cache and seems igmpproxy have done the right configuration about multicast routing in the kernel. All config are OK but muticast udp data can't forward. Any ideas? I'm exhausted to make all things right, help me! 

