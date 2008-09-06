Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbYIFXPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbYIFXPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbYIFXHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:07:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37877 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393AbYIFXHr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:07:47 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Gu Rui" <chaos.proton@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
In-Reply-To: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Wz8EH5sroeE.A.p_.TpwwIB@albercik>
Subject: [Bug #11418] Many soft lockups
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  6 Sep 2008 23:30:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11418
Subject		: Many soft lockups
Submitter	: Gu Rui <chaos.proton@gmail.com>
Date		: 2008-08-24 13:06 (14 days old)
Handled-By	: Thomas Gleixner <tglx@linutronix.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17622&action=view


