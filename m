Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbYDMTvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbYDMTvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbYDMTo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:44:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36973 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbYDMTop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:44:45 -0400
Cc: "Frans Pop" <elendil@planet.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
In-Reply-To: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oq66hWjeF4N.A.9N.N3lAIB@albercik>
Subject: [Bug #10428] [rc8] Regression: key repeats and skips in music during compilation
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Apr 2008 20:56:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.24.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10428
Subject		: [rc8] Regression: key repeats and skips in music during compilation
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-04-04 12:22 (10 days old)
References	: http://lkml.org/lkml/2008/4/4/83
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
		  Ingo Molnar <mingo@elte.hu>


