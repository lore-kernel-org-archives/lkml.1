Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbYLMSub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbYLMSub (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 13:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYLMSuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 13:50:18 -0500
Received: from mailbackup.inode.at ([213.229.60.24]:38412 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYLMSuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 13:50:17 -0500
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Dec 2008 13:50:17 EST
Message-ID: <4944026B.40301@sbg.ac.at>
Date: Sat, 13 Dec 2008 19:43:55 +0100
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.18 (X11/20081121)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel panics with net_rx_action on kernels >2.6.26
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

one of my machines (x86) crashes under heavy network load with kernels
>2.6.26, i tried quite everything possible between 2.6.27 and 2.6.28-rc8.

lspci -vv: http://xx.vu/~ahuemer/lspci_vv.txt
of the quad nic 2 ports are used, the machine is acting as a iptables
firewall/router.

kernel config (2.6.26) http://xx.vu/~ahuemer/config
screenshot of the panic:
http://xx.vu/~ahuemer/kernel_panic_net_rx_action.jpg

as i do not have any problems with kernels <=2.6.26, i doubt that this
is a hardware problem.
in case of the panic, nothing is written to the system log.

any hints welcome.
please CC me on replies, i am not subscribed to the  mailing list.

thanks in advance.

-- 
alex
