Return-Path: <linux-kernel-owner+w=401wt.eu-S1758500AbYDHX43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500AbYDHX43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 19:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbYDHXtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 19:49:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36741 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224AbYDHXtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 19:49:00 -0400
Cc: "Chr" <chunkeey@web.de>, "Thomas Gleixner" <tglx@linutronix.de>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SvnMeM-aZi.A.x8E.s-_-HB@albercik>
Subject: [Bug #10369] The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  9 Apr 2008 01:02:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.24.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10369
Subject		: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Submitter	: Chr <chunkeey@web.de>
Date		: 2008-03-30 21:09 (10 days old)
References	: http://lkml.org/lkml/2008/3/30/87
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


