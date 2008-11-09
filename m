Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYKITvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYKITvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 14:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYKITvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:51:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44316 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbYKITvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:51:02 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Reinette Chatre" <reinette.chatre@intel.com>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
In-Reply-To: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wnN9HICUAgP.A.kYB.L6zFJB@chimera>
Subject: [Bug #11806] iwl3945 fails with microcode error
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 18:54:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11806
Subject		: iwl3945 fails with microcode error
Submitter	: Johannes Berg <johannes@sipsolutions.net>
Date		: 2008-10-22 02:36 (19 days old)
References	: http://marc.info/?l=linux-kernel&m=122450235730661&w=4
Handled-By	: Reinette Chatre <reinette.chatre@intel.com>
Patch		: http://marc.info/?l=linux-wireless&m=122583010822172&w=2


