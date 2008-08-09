Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYHJATS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYHJATS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYHJAKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:10:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47398 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbYHJAKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:10:07 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Matthew Wilcox" <matthew@wil.cx>,
       "Matthew Wilcox" <willy@linux.intel.com>,
       "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
In-Reply-To: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX_-nNkxKaF.A._1H.lCjnIB@albercik>
Subject: [Bug #11283] MSI patch blamed for T60p not coming out of suspend to ram
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11283
Subject		: MSI patch blamed for T60p not coming out of suspend to ram
Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
Date		: 2008-08-07 16:07 (3 days old)


