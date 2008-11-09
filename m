Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbYKITzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbYKITzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 14:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbYKITzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:55:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44357 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838AbYKITzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:55:22 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Carlos R. Mafra" <crmafra2@gmail.com>, "Frans Pop" <elendil@planet.nl>,
       "Yves-Alexis Perez" <corsac@debian.org>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
In-Reply-To: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wnN9HICUAgP.A.vOB.E6zFJB@chimera>
Subject: [Bug #11826] extreme slowness of IO stuff using 2.6.28-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 18:59:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11826
Subject		: extreme slowness of IO stuff using 2.6.28-rc1
Submitter	: Yves-Alexis Perez <corsac@debian.org>
Date		: 2008-10-25 04:25 (16 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dc4304f7deee29fcdf6a2b62f7146ea7f505fd42
References	: http://marc.info/?l=linux-kernel&m=122521238402963&w=4
Handled-By	: Arjan van de Ven <arjan@linux.intel.com>


