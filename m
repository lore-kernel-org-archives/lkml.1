Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbYHPUmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbYHPUmo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYHPUdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:33:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37334 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbYHPUdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:33:18 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Brice Goglin" <brice@myri.com>, "Martin Michlmayr" <tbm@cyrius.com>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
In-Reply-To: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sNRO-BDDjQL.A.ZxE.XazpIB@albercik>
Subject: [Bug #11334] myri10ge: use ioremap_wc: compilation failure on ARM
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 Aug 2008 21:02:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11334
Subject		: myri10ge: use ioremap_wc: compilation failure on ARM
Submitter	: Martin Michlmayr <tbm@cyrius.com>
Date		: 2008-08-10 11:25 (7 days old)
References	: http://marc.info/?l=linux-netdev&m=121836771727632&w=2
Handled-By	: Brice Goglin <brice@myri.com>


