Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbYDMTt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbYDMTt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbYDMToy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:44:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36969 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117AbYDMToq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:44:46 -0400
Cc: "Roman Jarosz" <kedgedev@centrum.cz>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
In-Reply-To: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oq66hWjeF4N.A.yd.s3lAIB@albercik>
Subject: [Bug #10377] Kernel usually freezes during boot when AC is unplugged - unless CPU_IDLE=n - Asus A6JC
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Apr 2008 20:56:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.24.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10377
Subject		: Kernel usually freezes during boot when AC is unplugged - unless CPU_IDLE=n - Asus A6JC
Submitter	: Roman Jarosz <kedgedev@centrum.cz>
Date		: 2008-04-01 16:23 (13 days old)


