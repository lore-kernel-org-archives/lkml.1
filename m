Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbYH3Vj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbYH3Vj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758191AbYH3VZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:25:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758187AbYH3VZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:25:19 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       =?utf-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
In-Reply-To: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <N8SeMoDzuxC.A.rSE.PibuIB@albercik>
Subject: [Bug #11409] build issue #564 for v2.6.27-rc4 : undefined reference to `NS8390p_init'
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Aug 2008 21:50:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11409
Subject		: build issue #564 for v2.6.27-rc4 : undefined reference to `NS8390p_init'
Submitter	: Toralf Förster <toralf.foerster@gmx.de>
Date		: 2008-08-22 8:33 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=121939410214677&w=4
Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
Patch		: http://marc.info/?l=linux-kernel&m=121943097320451&w=4


