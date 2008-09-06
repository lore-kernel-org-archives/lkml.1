Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbYIFXKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbYIFXKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbYIFXGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:06:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37802 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428AbYIFXGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:06:45 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Josh Boyer" <jwboyer@linux.vnet.ibm.com>
References: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
In-Reply-To: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Wz8EH5sroeE.A.T3C.1rwwIB@albercik>
Subject: [Bug #11230] Kconfig no longer outputs a .config with freshly updated defconfigs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  6 Sep 2008 23:30:36 +0200 (CEST)
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
Date		: 2008-08-02 16:03 (36 days old)
References	: http://marc.info/?l=linux-kernel&m=121769306319391&w=4


