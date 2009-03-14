Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbZCNWCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbZCNWCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 18:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760671AbZCNV6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:58:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41857 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760483AbZCNV54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:57:56 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Michal Graczyk" <zazulas@gmail.com>, "Zhang Rui" <rui.zhang@intel.com>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
In-Reply-To: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <qm8_cedJGaP.A.emG.pOCvJB@chimera>
Subject: [Bug #12798] No wake up after suspend.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Mar 2009 20:20:19 +0100 (CET)
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
Date		: 2009-03-01 15:30 (14 days old)
Handled-By	: Zhang Rui <rui.zhang@intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=20402&action=view


