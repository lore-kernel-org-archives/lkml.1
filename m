Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbYDMTtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbYDMTtm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbYDMToz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:44:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36982 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883AbYDMTor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:44:47 -0400
Cc: "David Brownell" <david-b@pacbell.net>, "H. Peter Anvin" <hpa@zytor.com>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
In-Reply-To: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oq66hWjeF4N.A.FRB.C6lAIB@albercik>
Subject: [Bug #10153] (regression) kernel/timeconst.h bugs with HZ=128
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Apr 2008 20:56:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.24.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10153
Subject		: (regression) kernel/timeconst.h bugs with HZ=128
Submitter	: David Brownell <david-b@pacbell.net>
Date		: 2008-02-26 19:32 (48 days old)
References	: http://lkml.org/lkml/2008/2/26/294
Handled-By	: H. Peter Anvin <hpa@zytor.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15114&amp;action=view
		  http://bugzilla.kernel.org/attachment.cgi?id=15115&amp;action=view


