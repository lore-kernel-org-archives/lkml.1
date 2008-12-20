Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbYLUAMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbYLUAMA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 19:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYLUAKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 19:10:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49897 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbYLUAKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 19:10:20 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "alexs" <alex.shi@intel.com>,
       "James Bottomley" <James.Bottomley@HansenPartnership.com>,
       "Lin Ming" <ming.m.lin@intel.com>,
       "Michael Anderson" <andmike@linux.vnet.ibm.com>,
       "Yanmin Zhang" <yanmin_zhang@linux.intel.com>
References: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera>
In-Reply-To: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vy-yJy0f3YP.A.LAB.YaYTJB@chimera>
Subject: [Bug #12195] "dd" make kernel panic
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 20 Dec 2008 23:00:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12195
Subject		: "dd" make kernel panic
Submitter	: alexs <alex.shi@intel.com>
Date		: 2008-12-10 18:07 (11 days old)
Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>


