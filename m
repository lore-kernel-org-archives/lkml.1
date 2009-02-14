Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbZBNXQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbZBNXQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbZBNXH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:07:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44634 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590AbZBNXH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:07:56 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Valentin QUEQUET" <v.quequet-techniques@orange.fr>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
In-Reply-To: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rjPbZ5GRJPO.A.Q1D.Xr0lJB@chimera>
Subject: [Bug #12680] Not having a VIA PadLock hardware incurs a long delay in probing on modules insertion attempt.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Feb 2009 21:38:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12680
Subject		: Not having a VIA PadLock hardware incurs a long delay in probing on modules insertion attempt.
Submitter	: Valentin QUEQUET <v.quequet-techniques@orange.fr>
Date		: 2009-02-09 09:12 (6 days old)


