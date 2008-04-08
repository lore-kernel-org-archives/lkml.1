Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbYDHXus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbYDHXus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 19:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbYDHXsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 19:48:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36715 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755696AbYDHXsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 19:48:36 -0400
Cc: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SvnMeM-aZi.A.vaF.8__-HB@albercik>
Subject: [Bug #10290] [BUG] Linux 2.6.25-rc6 - kernel BUG at fs/mpage.c:476! on powerpc
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  9 Apr 2008 01:02:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.24.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10290
Subject		: [BUG] Linux 2.6.25-rc6 - kernel BUG at fs/mpage.c:476! on powerpc
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-03-20 13:13 (20 days old)
References	: http://lkml.org/lkml/2008/3/20/39


