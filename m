Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbYLDAGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbYLDAGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbYLDAC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:02:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48446 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757497AbYLDACv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:02:51 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Tomasz Chmielewski" <tch@wpkg.org>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
In-Reply-To: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <bfPM5B8Tx2B.A.ml.CqxNJB@chimera>
Subject: [Bug #11958] [2.6.27.x =&gt; 2.6.28-rc3] Xorg crash with xf86MapVidMem error
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  3 Dec 2008 22:57:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11958
Subject		: [2.6.27.x =&gt; 2.6.28-rc3] Xorg crash with xf86MapVidMem error
Submitter	: Tomasz Chmielewski <tch@wpkg.org>
Date		: 2008-11-05 05:37 (29 days old)


