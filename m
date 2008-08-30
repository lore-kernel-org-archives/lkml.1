Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbYH3Vax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbYH3Vax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbYH3VYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:24:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58151 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757583AbYH3VYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:24:38 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Larry Finger" <Larry.Finger@lwfinger.net>,
       "Sam Ravnborg" <sam@ravnborg.org>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
In-Reply-To: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <N8SeMoDzuxC.A.XNF.7ibuIB@albercik>
Subject: [Bug #11355] Regression in 2.6.27-rc2 when cross-building the kernel
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Aug 2008 21:50:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11355
Subject		: Regression in 2.6.27-rc2 when cross-building the kernel
Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
Date		: 2008-08-16 2:38 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=121885432118368&w=4
Handled-By	: Sam Ravnborg <sam@ravnborg.org>
		  David Woodhouse <dwmw2@infradead.org>


