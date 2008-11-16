Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbYKPShv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbYKPShv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbYKPSeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:34:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42934 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbYKPSeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:34:22 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Gene Heskett" <gene.heskett@gmail.com>
References: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
In-Reply-To: <VwdsQNEjR_C.A.CiD.9_FIJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q7OAnAv0V3D.A.aDG.bBGIJB@chimera>
Subject: [Bug #11906] 2.6.28-rc2 seems to fail at powering down the monitor when it should
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 16 Nov 2008 17:35:15 +0100 (CET)
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
Date		: 2008-10-30 6:39 (18 days old)
References	: http://marc.info/?l=linux-kernel&m=122534879721424&w=4


