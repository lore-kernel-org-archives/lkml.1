Return-Path: <linux-kernel-owner+w=401wt.eu-S1762671AbYF2Thi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762671AbYF2Thi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 15:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759503AbYF2Tb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:31:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45681 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758834AbYF2TbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:31:24 -0400
Cc: "Tobias Diedrich" <ranma+kernel@tdiedrich.de>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
In-Reply-To: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <X8mbwW6K81I.A.1FF.A89ZIB@albercik>
Subject: [Bug #10862] forcedeth: lockdep warning on ethtool -s
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 29 Jun 2008 20:18:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10862
Subject		: forcedeth: lockdep warning on ethtool -s
Submitter	: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Date		: 2008-06-01 8:37 (29 days old)
References	: http://marc.info/?l=linux-kernel&m=121230964032247&w=4


