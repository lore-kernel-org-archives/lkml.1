Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbYIFXNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbYIFXNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbYIFXH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:07:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37850 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396AbYIFXHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:07:22 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Tobias Diedrich" <ranma+kernel@tdiedrich.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
In-Reply-To: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Wz8EH5sroeE.A.CoB.6pwwIB@albercik>
Subject: [Bug #11358] net: forcedeth call restore mac addr in nv_shutdown path
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  6 Sep 2008 23:30:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11358
Subject		: net: forcedeth call restore mac addr in nv_shutdown path
Submitter	: Yinghai Lu <yhlu.kernel@gmail.com>
Date		: 2008-08-17 3:30 (21 days old)
References	: http://marc.info/?l=linux-kernel&m=121894389018584&w=4
Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=121894389018584&w=4


