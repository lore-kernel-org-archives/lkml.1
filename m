Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbYEXVcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbYEXVcp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 17:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758750AbYEXVcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 17:32:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40113 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbYEXVcf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 17:32:35 -0400
Cc: "Dave Chinner" <dgc@sgi.com>, "Plamen Petrov" <pvp-lsts@fs.ru.acad.bg>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
In-Reply-To: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TW_YzGo9TFP.A.f8F.7gIOIB@albercik>
Subject: [Bug #10582] INFO: task pdflush:27505 blocked for more than 120 seconds.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 24 May 2008 22:31:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10582
Subject		: INFO: task pdflush:27505 blocked for more than 120 seconds.
Submitter	: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
Date		: 2008-05-01 02:30 (24 days old)
References	: http://lkml.org/lkml/2008/5/19/20
Handled-By	: Dave Chinner <dgc@sgi.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15999


