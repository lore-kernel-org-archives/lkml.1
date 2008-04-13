Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbYDMTu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbYDMTu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbYDMTo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:44:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36981 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbYDMToq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:44:46 -0400
Cc: "Christoph Lameter" <clameter@sgi.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Nick Piggin" <npiggin@suse.de>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
In-Reply-To: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oq66hWjeF4N.A.-8H.I3lAIB@albercik>
Subject: [Bug #10449] mm/slab.c boot crash in -git, "kernel BUG at mm/slab.c:2103!"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Apr 2008 20:56:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.24.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10449
Subject		: mm/slab.c boot crash in -git, "kernel BUG at mm/slab.c:2103!"
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-04-11 03:42 (3 days old)
References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0804.1/1209.html
Handled-By	: Pekka Enberg <penberg@cs.helsinki.fi>
		  Nick Piggin <npiggin@suse.de>
		  Christoph Lameter <clameter@sgi.com>


