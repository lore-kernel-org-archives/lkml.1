Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbYHPUrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbYHPUrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbYHPUdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:33:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37374 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbYHPUdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:33:50 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
In-Reply-To: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sNRO-BDDjQL.A._JE.GazpIB@albercik>
Subject: [Bug #11341] 2.6.27-rc1 - ext4 e2fsck false prompting for fixing i_size of Inode
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 Aug 2008 21:02:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11341
Subject		: 2.6.27-rc1 - ext4 e2fsck false prompting for fixing i_size of Inode
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-08-13 6:56 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121861058720051&w=4


