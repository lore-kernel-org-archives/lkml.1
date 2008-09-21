Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYIUUqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYIUUqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbYIUUgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:36:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57206 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbYIUUgp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:36:45 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "David Brownell" <david-b@pacbell.net>,
       "Justin Mattock" <justinmattock@gmail.com>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
In-Reply-To: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7lIhZC4hCxE.A.vqG.X0q1IB@albercik>
Subject: [Bug #11552] Disabling IRQ #23
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Sep 2008 20:54:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11552
Subject		: Disabling IRQ #23
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2008-09-09 19:08 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=122098735230906&w=4
		  http://marc.info/?l=linux-kernel&m=122107367715361&w=4
Handled-By	: David Brownell <david-b@pacbell.net>
		  Alan Stern <stern@rowland.harvard.edu>
Patch		: http://marc.info/?l=linux-kernel&m=122187222705195&w=4


