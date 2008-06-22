Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbYFVTKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbYFVTKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbYFVTFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:05:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36264 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283AbYFVTFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:05:10 -0400
Cc: =?utf-8?q?Alejandro=20Riveira=20Fern=C3=A1ndez?= 
	<alejandro.riveira@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.jRD._spXIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4mRZUF-hVeG.A.GeF.jupXIB@albercik>
Subject: [Bug #10830] two different oopses with 2.6.26-rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 22 Jun 2008 19:54:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10830
Subject		: two different oopses with 2.6.26-rc4
Submitter	: Alejandro Riveira Fernández <alejandro.riveira@gmail.com>
Date		: 2008-05-28 9:50 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=121196833026310&w=4
Handled-By	: Johannes Berg <johannes@sipsolutions.net>
		  Andrew Morton <akpm@linux-foundation.org>
		  Peter Zijlstra <a.p.zijlstra@chello.nl>
Patch		: http://lkml.org/lkml/2008/5/20/683


