Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbYDHXs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbYDHXs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 19:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYDHXsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 19:48:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36699 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbYDHXsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 19:48:18 -0400
Cc: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Paul Mackerras" <paulus@samba.org>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SvnMeM-aZi.A.E8F.BCA_HB@albercik>
Subject: [Bug #10082] 2.6.25-rc2-git4 - Kernel oops  while running kernbench and tbench on powerpc
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  9 Apr 2008 01:02:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.24.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10082
Subject		: 2.6.25-rc2-git4 - Kernel oops while running kernbench and tbench on powerpc
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-02-20 16:01 (49 days old)
References	: http://lkml.org/lkml/2008/2/20/218
		  http://lkml.org/lkml/2008/1/18/71
Handled-By	: Paul Mackerras <paulus@samba.org>


