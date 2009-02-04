Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbZBDNBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbZBDNBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbZBDMui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:50:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45050 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbZBDMuf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:50:35 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Howells" <dhowells@redhat.com>,
       "David Smith" <dsmith@redhat.com>, "James Morris" <jmorris@namei.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.lpE.3uYiJB@chimera>
Subject: [Bug #12602] CRED changes causing setuid failures
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:24:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12602
Subject		: CRED changes causing setuid failures
Submitter	: David Smith <dsmith@redhat.com>
Date		: 2009-01-29 21:35 (7 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d84f4f992cbd76e8f39c488cf0c5d123843923b1
References	: http://marc.info/?l=linux-kernel&m=123326501813668&w=4


