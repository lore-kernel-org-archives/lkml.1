Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbYDMTpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbYDMTpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbYDMTop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:44:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36968 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbYDMTon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:44:43 -0400
Cc: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
In-Reply-To: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oq66hWjeF4N.A.oBB.v4lAIB@albercik>
Subject: [Bug #10290] [BUG] Linux 2.6.25-rc6 - kernel BUG at fs/mpage.c:476! on powerpc
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Apr 2008 20:56:41 +0200 (CEST)
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
Date		: 2008-03-20 13:13 (25 days old)
References	: http://lkml.org/lkml/2008/3/20/39


