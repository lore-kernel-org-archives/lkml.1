Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbYGFNIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbYGFNIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757515AbYGFNB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:01:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757133AbYGFNBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:01:06 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
In-Reply-To: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uBi7uNfg81L.A.zEB.bzLcIB@albercik>
Subject: [Bug #11023] 2.6.26-rc8-git2 - kernel BUG at mm/page_alloc.c:585
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Jul 2008 13:45:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11023
Subject		: 2.6.26-rc8-git2 - kernel BUG at mm/page_alloc.c:585
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-07-02 11:55 (5 days old)
References	: http://lkml.org/lkml/2008/7/2/32
Handled-By	: Andrew Morton <akpm@linux-foundation.org>


