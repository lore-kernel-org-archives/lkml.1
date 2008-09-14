Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbYINMRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbYINMRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 08:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYINMRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 08:17:47 -0400
Received: from mailsvr.yanbulink.net ([79.98.184.44]:35868 "EHLO
	mail.yanbulink.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbYINMRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 08:17:46 -0400
X-Greylist: delayed 1951 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Sep 2008 08:17:46 EDT
X-Spam-Flag: NO
X-Spam-Score: -4.063
Date: Sun, 14 Sep 2008 15:04:11 +0300 (AST)
From: "Wennie V. Lagmay" <wlagmay@yanbulink.net>
To: linux-kernel@vger.kernel.org
Cc: wlagmay <wlagmay@yanbulink.net>
Message-ID: <23541694.2961221393851646.JavaMail.root@mail.yanbulink.net>
Subject: Kernel upgarde causes IPTABLES SAME not working for me
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.24.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all, 

I am having a problem with the recent version of kernel (2.6.25-14-108) on Fedora Core 9 64 bit.
I am trying to enable the NATting using SAME command but I am getting an error "Iptables: No chain/target match by this name" but with earlier version of linux 2.6.23.1-42 iptables with SAME target is working; "iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j SAME --to 10.10.10.1-10.10.10.2 --nodst"

I also try to recompile a 2.6.25 kernel but there is no luck.  Can you please help me to activate SAME target on the latest release of  kernel probably from 2.6.23 and latest.

My objective is to have a multiple source private IP going/NATed to multiple destination public IP with voice chat enable. 

Please take note that using SNAT I cannot enable voice chat; using masquerade I can enable voice chat but this is not suitable to our requirements. The best suitable for us is using SAME.

Can you please help me solve this problem. Also please put me on Cc: on any reply or comment so that I can see all of your reply.

Thank you very much and best regards,

Wennie


