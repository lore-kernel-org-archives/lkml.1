Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab0BUWG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:06:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59064 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003Ab0BUWGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:06:09 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Oliver Neukum" <oliver@neukum.org>
References: <4u4d-2M3yXH.A.XW.XqagLB@chimera>
In-Reply-To: <4u4d-2M3yXH.A.XW.XqagLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wj3ZQZlk_KB.A.ORB.PragLB@chimera>
Subject: [Bug #15134] gobi_loader hangs after commit 8e8dce065088
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Feb 2010 22:42:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15134
Subject		: gobi_loader hangs after commit 8e8dce065088
Submitter	: Matthew Garrett <mjg59@srcf.ucam.org>
Date		: 2010-01-17 2:55 (36 days old)
References	: http://marc.info/?l=linux-kernel&m=126369696509502&w=4
Handled-By	: Oliver Neukum <oliver@neukum.org>
		  Alan Cox <alan@lxorguk.ukuu.org.uk>


