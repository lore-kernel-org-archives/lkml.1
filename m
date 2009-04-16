Return-Path: <linux-kernel-owner+w=401wt.eu-S1760441AbZDQAmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441AbZDQAmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759716AbZDQAet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:34:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36603 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759021AbZDQAer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:34:47 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Len Brown" <len.brown@intel.com>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Maxim Levitsky" <maximlevitsky@gmail.com>,
       "Thomas Renninger" <trenn@suse.de>, "Zhang Rui" <rui.zhang@intel.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nY3-4PrO6XH.A.B-G.Dw85JB@chimera>
Subject: [Bug #13121] commit 1a7c618a3f7bef1a20ae740df512eeba21397fa5 breaks ACPI video
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 16 Apr 2009 23:45:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13121
Subject		: commit 1a7c618a3f7bef1a20ae740df512eeba21397fa5 breaks ACPI video
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
Date		: 2009-04-16 11:37 (1 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1a7c618a3f7bef1a20ae740df512eeba21397fa5
References	: http://marc.info/?l=linux-kernel&m=123988189401913&w=4


