Return-Path: <linux-kernel-owner+w=401wt.eu-S1760375AbZCCWWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375AbZCCWWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761281AbZCCWQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:16:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39678 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761507AbZCCWQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:16:12 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Michal Graczyk" <zazulas@gmail.com>, "Zhang Rui" <rui.zhang@intel.com>
References: <r4SCKuuJK0F.A.UrB.QdarJB@chimera>
In-Reply-To: <r4SCKuuJK0F.A.UrB.QdarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pRIaSZpQ1ON.A.nvB.UdarJB@chimera>
Subject: [Bug #12798] No wake up after suspend.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:41:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12798
Subject		: No wake up after suspend.
Submitter	: Michal Graczyk <zazulas@gmail.com>
Date		: 2009-03-01 15:30 (3 days old)
Handled-By	: Zhang Rui <rui.zhang@intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=20402&action=view


