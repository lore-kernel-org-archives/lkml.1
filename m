Return-Path: <linux-kernel-owner+w=401wt.eu-S1761449AbYFGVz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761449AbYFGVz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 17:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbYFGVsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:48:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38956 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757418AbYFGVsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:48:32 -0400
Cc: "Adrian Bunk" <adrian.bunk@movial.fi>,
       "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>,
       "Chris Dearman" <chris@mips.com>, "Ralf Baechle" <ralf@linux-mips.org>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
In-Reply-To: <GIilET9wkhI.A.JzB.81vSIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dCRO4tbfLzK.A.2iD.P3vSIB@albercik>
Subject: [Bug #10794] mips: CONF_CM_DEFAULT build error
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  7 Jun 2008 22:42:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10794
Subject		: mips: CONF_CM_DEFAULT build error
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-05-25 10:11 (14 days old)
References	: http://lkml.org/lkml/2008/5/25/168
Patch		: http://lkml.org/lkml/2008/6/1/125


