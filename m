Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYHLT4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYHLT4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYHLT4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:56:00 -0400
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:23227 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYHLTz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:55:59 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Aug 2008 15:55:59 EDT
From: Konrad Rzeszutek <ketuzsezr@darnok.org>
To: gregkh@suse.de
Cc: pjones@redhat.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/firmware/iscsi_ibft.c: make 3 functions static
Date: Tue, 12 Aug 2008 15:43:58 -0400
Message-Id: <1218570239-17766-1-git-send-email-ketuzsezr@darnok.org>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080423095230.GK28933@cs181133002.pp.htv.fi>
References: <20080423095230.GK28933@cs181133002.pp.htv.fi>
X-Junkmail-Status: score=10/50, host=mr08.lnh.mail.rcn.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A010202.48A1E88A.0064,ss=1,fgs=0,
	ip=207.172.4.11,
	so=2007-10-30 19:00:17,
	dmn=5.4.3/2008-02-01
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg,

Please at your convience include this patch in your update to the drivers/firmware directory if it
is not too much trouble.

Thank you,

Konrad Rzeszutek



 iscsi_ibft.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)


