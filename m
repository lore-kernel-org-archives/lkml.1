Return-Path: <linux-kernel-owner+w=401wt.eu-S1760391AbYHBTdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760391AbYHBTdP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 15:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759287AbYHBT2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 15:28:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38035 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759286AbYHBT2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 15:28:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alistair John Strachan" <alistair@devzero.co.uk>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
References: <cbItfVMShGI.A.olC.UMLlIB@albercik>
In-Reply-To: <cbItfVMShGI.A.olC.UMLlIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5ZeQ4vXWqRC.A.TZE.gNLlIB@albercik>
Subject: [Bug #11197] Oops in microcode sysfs registration
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  2 Aug 2008 20:04:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed
and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11197
Subject		: Oops in microcode sysfs registration
Submitter	: Alistair John Strachan <alistair@devzero.co.uk>
Date		: 2008-07-29 13:57 (5 days old)
References	: http://marc.info/?t=121734004900002&r=1&w=4
Handled-By	: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Patch		: http://marc.info/?l=linux-kernel&m=121741431005777&w=4


