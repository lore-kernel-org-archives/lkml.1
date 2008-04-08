Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbYDHX4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbYDHX4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 19:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbYDHXtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 19:49:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36755 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169AbYDHXs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 19:48:58 -0400
Cc: "Roman Jarosz" <kedgedev@centrum.cz>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SvnMeM-aZi.A.N5E.n-_-HB@albercik>
Subject: [Bug #10377] Kernel freezes during boot when AC is unplugged
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  9 Apr 2008 01:02:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.24.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10377
Subject		: Kernel freezes during boot when AC is unplugged
Submitter	: Roman Jarosz <kedgedev@centrum.cz>
Date		: 2008-04-01 16:23 (8 days old)


