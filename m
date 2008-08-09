Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbYHJARx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbYHJARx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbYHJAK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:10:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47347 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189AbYHJAKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:10:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Grant Coady" <grant_lkml@dodo.com.au>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
In-Reply-To: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX_-nNkxKaF.A.WR.xCjnIB@albercik>
Subject: [Bug #11278] 2.6.27-rc2: Very odd top: '5124095h kthreadd' display
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Aug 2008 00:43:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11278
Subject		: 2.6.27-rc2: Very odd top: '5124095h kthreadd' display
Submitter	: Grant Coady <grant_lkml@dodo.com.au>
Date		: 2008-08-07 7:03 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121809267318795&w=4


