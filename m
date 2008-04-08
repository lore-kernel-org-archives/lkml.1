Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYDHXpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYDHXpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 19:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYDHXpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 19:45:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36679 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbYDHXpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 19:45:35 -0400
Cc: =?utf-8?q?Bj=C3=B6rn=20Steinbrink?= <B.Steinbrink@gmx.de>,
       "Bob Tracy" <rct@frus.com>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SvnMeM-aZi.A.cBF.w-_-HB@albercik>
Subject: [Bug #10366] 2.6.25-rc7: warn_on_slowpath triggered
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  9 Apr 2008 00:59:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.24.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10366
Subject		: 2.6.25-rc7: warn_on_slowpath triggered
Submitter	: Bob Tracy <rct@frus.com>
Date		: 2008-03-29 17:29 (11 days old)
References	: http://lkml.org/lkml/2008/3/29/125
Handled-By	: Björn Steinbrink <B.Steinbrink@gmx.de>
Patch		: http://lkml.org/lkml/2008/3/30/245


