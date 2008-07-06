Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbYGFNG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbYGFNG0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbYGFNB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:01:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54483 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757294AbYGFNBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:01:06 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andy Whitcroft" <apw@shadowen.org>,
       "Dan Williams" <dan.j.williams@intel.com>,
       "Lee Schermerhorn" <lee.schermerhorn@hp.com>,
       "Mel Gorman" <mel@csn.ul.ie>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
In-Reply-To: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uBi7uNfg81L.A.z4.WzLcIB@albercik>
Subject: [Bug #11025] [problem] raid performance loss with 2.6.26-rc8 on 32-bit x86 (bisected)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Jul 2008 13:45:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11025
Subject		: [problem] raid performance loss with 2.6.26-rc8 on 32-bit x86 (bisected)
Submitter	: Dan Williams <dan.j.williams@intel.com>
Date		: 2008-07-01 1:57 (6 days old)
References	: http://marc.info/?l=linux-kernel&m=121487749429883&w=4
Handled-By	: Mel Gorman <mel@csn.ul.ie>
		  Andy Whitcroft <apw@shadowen.org>


