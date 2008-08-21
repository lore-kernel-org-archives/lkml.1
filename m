Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbYHUEFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbYHUEFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 00:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYHUEFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 00:05:45 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:56650 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYHUEFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 00:05:44 -0400
Message-ID: <48ACE990.6000500@davidnewall.com>
Date: Thu, 21 Aug 2008 13:35:36 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Chen Pei Chao <jackie73@ms2.hinet.net>
CC: linux-kernel@vger.kernel.org, jackie.chen@foxconn.com
Subject: =?windows-1255?Q?Re=3A_Is_there_linux_RAM_filesystem_?=
 =?windows-1255?Q?with_a_fixed_amount_of_memory=3F=FE?=
References: <01c301c9033c$5e881ef0$4901a8c0@tc.nsbg.efoxconn.com>
In-Reply-To: <01c301c9033c$5e881ef0$4901a8c0@tc.nsbg.efoxconn.com>
Content-Type: text/plain; charset=windows-1255
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Pei Chao wrote:
> I mounted a ramfs filesystem with 10M size, and have a check of
> /proc/meminfo.
> I find the ramfs also did not have the memory preallocation.
>   
Apparently I misunderstood what ramfs does.  Sorry for misdirecting you.
