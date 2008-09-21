Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYIUUe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYIUUe6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYIUUeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:34:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57080 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbYIUUep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:34:45 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Josh Boyer" <jwboyer@linux.vnet.ibm.com>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
In-Reply-To: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7lIhZC4hCxE.A.nbB.A4q1IB@albercik>
Subject: [Bug #11230] Kconfig no longer outputs a .config with freshly updated defconfigs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Sep 2008 20:54:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11230
Subject		: Kconfig no longer outputs a .config with freshly updated defconfigs
Submitter	: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date		: 2008-08-02 16:03 (51 days old)
References	: http://marc.info/?l=linux-kernel&m=121769306319391&w=4


