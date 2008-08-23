Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYHWTsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYHWTsH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbYHWTmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:42:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50144 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbYHWTmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:42:20 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
In-Reply-To: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <VSpL6AnBTS.A.bQ.GbGsIB@albercik>
Subject: [Bug #11335] 2.6.27-rc2-git5 BUG: unable to handle kernel paging request
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 23 Aug 2008 20:10:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11335
Subject		: 2.6.27-rc2-git5 BUG: unable to handle kernel paging request
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-08-12 4:18 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=121851477201960&w=4
		  http://lkml.org/lkml/2008/8/16/274
Handled-By	: Hugh Dickins <hugh@veritas.com>


