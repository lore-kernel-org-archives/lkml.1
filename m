Return-Path: <linux-kernel-owner+w=401wt.eu-S1758445AbYKIUGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445AbYKIUGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbYKIT5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:57:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44504 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807AbYKIT5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:57:18 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Doug Nazar" <nazard@dragoninc.ca>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Jeff Garzik" <jeff@garzik.org>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
In-Reply-To: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wnN9HICUAgP.A.DUF.W4zFJB@chimera>
Subject: [Bug #11985] 2.6.28-rc3 truncates nfsd results
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Nov 2008 18:59:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11985
Subject		: 2.6.28-rc3 truncates nfsd results
Submitter	: Doug Nazar <nazard@dragoninc.ca>
Date		: 2008-11-04 18:27 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=122582366509153&w=4
Handled-By	: Doug Nazar <nazard@dragoninc.ca>
		  J. Bruce Fields <bfields@fieldses.org>
Patch		: http://marc.info/?l=linux-kernel&m=122592648119790&w=4


