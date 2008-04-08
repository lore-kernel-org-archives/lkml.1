Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbYDHXwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbYDHXwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 19:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbYDHXs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 19:48:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36741 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121AbYDHXs4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 19:48:56 -0400
Cc: "Marcus Better" <marcus@better.se>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SvnMeM-aZi.A.YKF.D__-HB@albercik>
Subject: [Bug #10326] inconsistent lock state in net_rx_action
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  9 Apr 2008 01:02:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.24.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10326
Subject		: inconsistent lock state in net_rx_action
Submitter	: Marcus Better <marcus@better.se>
Date		: 2008-03-25 13:21 (15 days old)
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=10326#c20


