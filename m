Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbZCCWPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbZCCWPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbZCCWOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:14:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39602 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515AbZCCWOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:14:52 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andreas Mohr" <andi@lisas.de>
References: <r4SCKuuJK0F.A.UrB.QdarJB@chimera>
In-Reply-To: <r4SCKuuJK0F.A.UrB.QdarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pRIaSZpQ1ON.A.xnD.hearJB@chimera>
Subject: [Bug #12209] oldish top core dumps (in its meminfo() function)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:41:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12209
Subject		: oldish top core dumps (in its meminfo() function)
Submitter	: Andreas Mohr <andi@lisas.de>
Date		: 2008-12-12 18:49 (82 days old)
References	: http://marc.info/?l=linux-kernel&m=122910784006472&w=4
		  http://marc.info/?l=linux-kernel&m=122907511319288&w=4


