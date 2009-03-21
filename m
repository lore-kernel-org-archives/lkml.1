Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbZCUTXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbZCUTXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbZCUTTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:19:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51894 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277AbZCUTSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:18:55 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@redhat.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "=?utf-8?q?Michel=20D=C3=A4nzer?=" <michel@daenzer.net>,
       "Sitsofe Wheeler" <sitsofe@yahoo.com>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
In-Reply-To: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <l8NZ2a3iQtG.A.2TB.UaTxJB@chimera>
Subject: [Bug #12765] i915 VT switch with AIGLX causes X lock up
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Mar 2009 17:39:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12765
Subject		: i915 VT switch with AIGLX causes X lock up
Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
Date		: 2009-02-21 15:38 (29 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=14d200c5e5bd19219d930bbb9a5a22758c8f5bec
References	: http://marc.info/?l=linux-kernel&m=123523074304955&w=4


