Return-Path: <linux-kernel-owner+w=401wt.eu-S1762908AbYERM2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762908AbYERM2B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759673AbYERMNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:13:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58375 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759126AbYERMNi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:13:38 -0400
Cc: "Ioan Ionita" <opslynx@gmail.com>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
In-Reply-To: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7wuznNhcUqC.A.JMG.XrBMIB@albercik>
Subject: [Bug #10742] BISECTED REGRESSION: 2.6.26-rc2: FUSE changes break mount of ntfs-3g
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 18 May 2008 13:13:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10742
Subject		: BISECTED REGRESSION: 2.6.26-rc2: FUSE changes break mount of ntfs-3g
Submitter	: Ioan Ionita <opslynx@gmail.com>
Date		: 2008-05-17 20:37 (2 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121105669717787&amp;w=4


