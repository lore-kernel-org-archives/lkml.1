Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbZBHV4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbZBHV4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZBHVtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:49:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39659 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956AbZBHVtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:49:00 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Larry Finger" <Larry.Finger@lwfinger.net>,
       "Mikael Pettersson" <mikpe@it.uu.se>,
       "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sWhNs83kKPE.A.E5F.w20jJB@chimera>
Subject: [Bug #12609] v2.6.29-rc2 libata sff 32bit PIO regression
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  8 Feb 2009 20:21:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12609
Subject		: v2.6.29-rc2 libata sff 32bit PIO regression
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2009-01-23 23:52 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=123275478111406&w=4
		  http://marc.info/?l=linux-kernel&m=123254501314058&w=4
Handled-By	: Mikael Pettersson <mikpe@it.uu.se>
		  Hugh Dickins <hugh@veritas.com>
		  Sergei Shtylyov <sshtylyov@ru.mvista.com>
Patch		: http://marc.info/?l=linux-kernel&m=123412278730735&w=4


