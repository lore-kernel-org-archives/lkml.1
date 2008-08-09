Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYHJAQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYHJAQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbYHJAK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:10:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47398 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbYHJAKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:10:04 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Sesterhenn" <snakebyte@gmx.de>, "Rabin Vincent" <rabin@rab.in>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
In-Reply-To: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX_-nNkxKaF.A.Ks.8CjnIB@albercik>
Subject: [Bug #11274] Oops when accessing /proc/lockdep_chains
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11274
Subject		: Oops when accessing /proc/lockdep_chains
Submitter	: Eric Sesterhenn <snakebyte@gmx.de>
Date		: 2008-08-06 12:16 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121802509626294&w=4
Handled-By	: Rabin Vincent <rabin@rab.in>
Patch		: http://marc.info/?l=linux-kernel&m=121814269607276&w=4


