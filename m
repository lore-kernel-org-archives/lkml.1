Return-Path: <linux-kernel-owner+w=401wt.eu-S1765419AbYFGV5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765419AbYFGV5d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 17:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760095AbYFGVsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:48:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38945 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759042AbYFGVse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:48:34 -0400
Cc: "Jan Engelhardt" <jengelh@medozas.de>, "thunder7" <thunder7@xs4all.nl>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
In-Reply-To: <GIilET9wkhI.A.JzB.81vSIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dCRO4tbfLzK.A.vND.B3vSIB@albercik>
Subject: [Bug #10816] vt/fbcon: fix background color on line feed
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  7 Jun 2008 22:42:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10816
Subject		: vt/fbcon: fix background color on line feed
Submitter	: thunder7 <thunder7@xs4all.nl>
Date		: 2008-05-27 19:33 (12 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121191733218735&amp;w=4
Handled-By	: Jan Engelhardt <jengelh@medozas.de>
Patch		: http://marc.info/?l=linux-kernel&amp;m=121199453010047&amp;w=4


