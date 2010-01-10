Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545Ab0AJWn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab0AJWn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314Ab0AJWle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:41:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57945 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab0AJWld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:41:33 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Chow Loong Jin" <hyperair@ubuntu.com>,
       "Matt Carlson" <mcarlson@broadcom.com>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
In-Reply-To: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <omZ8aBZReyD.A.46G.ANlSLB@chimera>
Subject: [Bug #14974] tg3 does not resume from hibernation properly on BCM5787M
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:32:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14974
Subject		: tg3 does not resume from hibernation properly on BCM5787M
Submitter	: Chow Loong Jin <hyperair@ubuntu.com>
Date		: 2010-01-02 05:30 (9 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=87668d352aa8d135bd695a050f18bbfc7b50b506
Handled-By	: Matt Carlson <mcarlson@broadcom.com>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=14974#c12


