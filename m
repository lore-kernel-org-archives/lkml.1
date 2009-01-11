Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbZAKN3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbZAKN3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZAKN3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:29:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36585 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbZAKN2z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:28:55 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
In-Reply-To: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oWTznAnH9BI.A.9V.bHfaJB@chimera>
Subject: [Bug #12399] USB wakeup problem on Toshiba Portege R500
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:12:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12399
Subject		: USB wakeup problem on Toshiba Portege R500
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2009-01-08 7:35 (4 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6fd9086a518d4f14213a32fe6c9ac17fabebbc1e
References	: http://marc.info/?l=linux-kernel&m=123140019117968&w=4


