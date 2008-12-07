Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbYLGWoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbYLGWoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 17:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbYLGWjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 17:39:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35020 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661AbYLGWjb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 17:39:31 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Li Zefan" <lizf@cn.fujitsu.com>
References: <6VnlupFpCsN.A.2rE.MsEPJB@chimera>
In-Reply-To: <6VnlupFpCsN.A.2rE.MsEPJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <07Xes05z25M.A.b-E.SsEPJB@chimera>
Subject: [Bug #12177] [memcg BUG ?] failed to boot on IA64 with CONFIG_DISCONTIGMEM=y
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Dec 2008 21:32:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12177
Subject		: [memcg BUG ?] failed to boot on IA64 with CONFIG_DISCONTIGMEM=y
Submitter	: Li Zefan <lizf@cn.fujitsu.com>
Date		: 2008-12-05 3:09 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=122844668532752&w=4
Handled-By	: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Patch		: http://marc.info/?l=linux-kernel&m=122844757701505&w=4


