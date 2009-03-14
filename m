Return-Path: <linux-kernel-owner+w=401wt.eu-S1759451AbZCNV5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbZCNV5l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbZCNV5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:57:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41824 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbZCNV5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:57:12 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrey Vul" <andrey.vul@gmail.com>,
       "Francois Romieu" <romieu@fr.zoreil.com>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
In-Reply-To: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <qm8_cedJGaP.A.lhH.NPCvJB@chimera>
Subject: [Bug #12411] 2.6.28: BUG in r8169
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Mar 2009 20:20:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12411
Subject		: 2.6.28: BUG in r8169
Submitter	: Andrey Vul <andrey.vul@gmail.com>
Date		: 2008-12-31 18:37 (74 days old)
References	: http://marc.info/?l=linux-kernel&m=123074869611409&w=4


