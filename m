Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbYHJAOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbYHJAOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbYHJAKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:10:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbYHJAKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:10:00 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alex Villacis Lasso" <avillaci@ceibo.fiec.espol.edu.ec>,
       "Hugh Dickins" <hugh@veritas.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
In-Reply-To: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX_-nNkxKaF.A.fVB.TDjnIB@albercik>
Subject: [Bug #11260] Regression: USB memory stick triggers several USB resets before settling with bogus capacity
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Aug 2008 00:43:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11260
Subject		: Regression: USB memory stick triggers several USB resets before settling with bogus capacity
Submitter	: Alex Villacis Lasso <avillaci@ceibo.fiec.espol.edu.ec>
Date		: 2008-08-06 13:33 (4 days old)
Handled-By	: Hugh Dickins <hugh@veritas.com>
Patch		: http://marc.info/?l=linux-kernel&m=121804333614405&w=2


