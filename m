Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYKBSLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYKBSLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbYKBSCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:02:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35725 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbYKBSCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:02:51 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Gene Heskett" <gene.heskett@gmail.com>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
In-Reply-To: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wOAXuecskPD.A.IJF.AkeDJB@chimera>
Subject: [Bug #11906] 2.6.28-rc2 seems to fail at powering down the monitor when it should
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Nov 2008 17:07:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11906
Subject		: 2.6.28-rc2 seems to fail at powering down the monitor when it should
Submitter	: Gene Heskett <gene.heskett@gmail.com>
Date		: 2008-10-30 6:39 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=122534879721424&w=4


