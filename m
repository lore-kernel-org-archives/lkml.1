Return-Path: <linux-kernel-owner+w=401wt.eu-S1762060AbYB1BRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762060AbYB1BRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbYB1BRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:17:40 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:49985 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454AbYB1BRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:17:40 -0500
X-Authority-Analysis: v=1.0 c=1 a=Siy3sSQzJz4A:10
 a=bojhYoMd2USPMMK5XVEeMQ==:17 a=VwQbUJbxAAAA:8 a=Pv65RNnyiULXxRGZzlcA:9
 a=Hk5zSycA1LOBvpa1QIQA:7 a=47JB7x33ejXMM4GbnqDmbMPYCvAA:4 a=4N9Db7Z2_RYA:10
 a=8t_6ZPhla3UA:10
From: kelk1@comcast.net (Quel Qun)
To: David Miller <davem@davemloft.net>, marcel@holtmann.org
Cc: tglx@linutronix.de, dwmw2@infradead.org, hidave.darkstar@gmail.com,
       linux-kernel@vger.kernel.org, jkosina@suse.cz, mingo@elte.hu
Subject: Re: [PATCH] bluetooth: delete timer in l2cap_conn_del()
Date: Thu, 28 Feb 2008 01:17:14 +0000
Message-Id: <022820080117.5258.47C60B9A0001B56A0000148A2200750784CE05040A05@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct 30 2007)
X-Authenticated-Sender: a2VsazFAY29tY2FzdC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 -------------- Original message ----------------------
From: David Miller <davem@davemloft.net>
> 
> Marcel/Dave, can you or someone else followup with
> the bug reporter to get their dongle working now that
> the OOPS problem is fixed?
> 
> Let's not lose track of this bug, thanks.

I entered #10126

http://bugzilla.kernel.org/show_bug.cgi?id=10126

Thank you,
--
kk1
