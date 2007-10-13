Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbXJMLtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbXJMLtf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 07:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbXJMLt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 07:49:27 -0400
Received: from mail1.bizmail.net.au ([60.246.2.164]:57272 "EHLO
	mail1.bizmail.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbXJMLt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 07:49:27 -0400
X-Greylist: delayed 1398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Oct 2007 07:49:22 EDT
Message-ID: <4710AB5A.1080705@gmail.com>
Date: Sat, 13 Oct 2007 21:26:18 +1000
From: YH <jupiter.hce@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.11) Gecko/20050729
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Why the bond0 is set on kernel 2.6.22?
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am using an ARM processor with CS8900 Ethernet card, it works fine in 
kernel 2.6.11. But, recently I upgraded it to kernel 2.6.22, the 
ipconfig.c started up a bond0 instead of eth0 with an IP address I 
actually assigned to eth0 in cs89x0.c. The trouble was I cannot event 
ping the ip address. Any advice why this was happend and how to fix it?

Thank you.

Jim
