Return-Path: <linux-kernel-owner+w=401wt.eu-S1761557AbYHBTiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557AbYHBTiZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759751AbYHBT2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:28:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38044 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758337AbYHBT2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:28:18 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mikael Pettersson" <mikpe@it.uu.se>
References: <cbItfVMShGI.A.olC.UMLlIB@albercik>
In-Reply-To: <cbItfVMShGI.A.olC.UMLlIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5ZeQ4vXWqRC.A.PFE.SNLlIB@albercik>
Subject: [Bug #11205] x86: 2.6.27-rc1 does not build with gcc-3.2.3 any more
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  2 Aug 2008 20:04:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed
and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11205
Subject		: x86: 2.6.27-rc1 does not build with gcc-3.2.3 any more
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-07-30 11:02 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=121741584608240&w=4


