Return-Path: <linux-kernel-owner+w=401wt.eu-S1759064AbYKVWgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064AbYKVWgF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbYKVWaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:30:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37770 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086AbYKVWaJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:30:09 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ian Campbell" <Ian.Campbell@citrix.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.YwB.K7HKJB@chimera>
Subject: [Bug #12081] xen: pin correct PGD on suspend
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12081
Subject		: xen: pin correct PGD on suspend
Submitter	: Ian Campbell <Ian.Campbell@citrix.com>
Date		: 2008-11-21 10:21 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=122726293324850&w=4
Handled-By	: Ian Campbell <Ian.Campbell@citrix.com>
Patch		: http://marc.info/?l=linux-kernel&m=122726293324850&w=4


