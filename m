Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbYDMTri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbYDMTri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbYDMTou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:44:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36968 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056AbYDMTop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:44:45 -0400
Cc: "Chr" <chunkeey@web.de>, "Thomas Gleixner" <tglx@linutronix.de>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
In-Reply-To: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oq66hWjeF4N.A.ch.w3lAIB@albercik>
Subject: [Bug #10369] The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Apr 2008 20:56:42 +0200 (CEST)
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
Date		: 2008-03-30 21:09 (15 days old)
References	: http://lkml.org/lkml/2008/3/30/87
Handled-By	: Thomas Gleixner <tglx@linutronix.de>


