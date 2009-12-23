Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbZLVWUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbZLVWUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 17:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZLVWUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 17:20:14 -0500
Received: from cnmailgate04.alcatel-sbell.com.cn ([211.144.215.47]:49655 "EHLO
	cnshjsmin03.cn.alcatel-lucent.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752127AbZLVWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 17:20:14 -0500
X-Greylist: delayed 1751 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Dec 2009 17:20:13 EST
X-AuditID: ac189297-aaf7abb000000980-df-4b313ece35ce
Message-ID: <4B31F5D7.3010500@alcatel-lucent.com>
Date: Wed, 23 Dec 2009 05:49:59 -0500
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: how to suspend/resume SCSI ATA driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Dec 2009 21:50:08.0002 (UTC) FILETIME=[BA51B620:01CA8350]
X-Brightmail-Tracker: AAAAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've a SCSI based SATA driver installed on my system. XMON has been 
enabled either.
When I invoked xmon for kernel debugging and then exit from xmon a while 
later. SCSI
Host always reported operations timeout'ed. So I want to suspend SCSI 
SATA device
before entering xmon and resume it when I'm back from xmon. I'm not sure 
there is
a way to do this?

Thanks in advance,
Gavin
