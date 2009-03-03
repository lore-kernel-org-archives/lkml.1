Return-Path: <linux-kernel-owner+w=401wt.eu-S1762730AbZCCWVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762730AbZCCWVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760647AbZCCWQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:16:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39663 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759946AbZCCWQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:16:04 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bob Raitz" <pappy_mcfae@yahoo.com>
References: <r4SCKuuJK0F.A.UrB.QdarJB@chimera>
In-Reply-To: <r4SCKuuJK0F.A.UrB.QdarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pRIaSZpQ1ON.A.1BC.edarJB@chimera>
Subject: [Bug #12634] video distortion and lockup with i830 video chip and 2.6.28.3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:41:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12634
Subject		: video distortion and lockup with i830 video chip and 2.6.28.3
Submitter	: Bob Raitz <pappy_mcfae@yahoo.com>
Date		: 2009-02-04 21:10 (28 days old)


