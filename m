Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544Ab0AJWoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0AJWoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540Ab0AJWn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:43:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57949 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321Ab0AJWle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:41:34 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Yan, Zheng" <yanzheng@21cn.com>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
In-Reply-To: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <omZ8aBZReyD.A.0sG.6MlSLB@chimera>
Subject: [Bug #15031] bug in fs/btrfs/ordered-data.c:672
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:32:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15031
Subject		: bug in fs/btrfs/ordered-data.c:672
Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
Date		: 2010-01-02 11:32 (9 days old)
References	: http://lkml.org/lkml/2010/1/2/17
Handled-By	: Yan, Zheng <yanzheng@21cn.com>
Patch		: http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03686.html


