Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbZL2PNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbZL2PNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbZL2PNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:13:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38897 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbZL2PNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:13:11 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Anisse Astier" <anisse@astier.eu>,
       "Carlos Corbacho" <carlos@strangeworlds.co.uk>,
       "Len Brown" <len.brown@intel.com>,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Sedat Dilek" <sedat.dilek@googlemail.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
In-Reply-To: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <NJVdobuNFNK.A.wb.hnhOLB@chimera>
Subject: [Bug #14890] [WMI?] boot hang
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 29 Dec 2009 16:09:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14890
Subject		: [WMI?] boot hang
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2009-12-25 10:10 (5 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3e9b988e4edf065d39c1343937f717319b1c1065
References	: http://marc.info/?l=linux-kernel&m=126173586309724&w=4
		  http://marc.info/?l=linux-kernel&m=126170348921630&w=4


