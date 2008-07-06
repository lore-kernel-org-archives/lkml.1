Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYGFNDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYGFNDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbYGFNBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:01:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756862AbYGFNBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:01:03 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Manfred Spraul" <manfred@colorfullife.com>,
       "Pekka J Enberg" <penberg@cs.helsinki.fi>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
In-Reply-To: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <uBi7uNfg81L.A.KEC.i0LcIB@albercik>
Subject: [Bug #10906] repeatable slab corruption with LTP msgctl08
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Jul 2008 13:45:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10906
Subject		: repeatable slab corruption with LTP msgctl08
Submitter	: Andrew Morton <akpm@linux-foundation.org>
Date		: 2008-06-12 5:13 (25 days old)
References	: http://marc.info/?l=linux-kernel&m=121324775927704&w=4
Handled-By	: Pekka J Enberg <penberg@cs.helsinki.fi>
		  Christoph Lameter <clameter@sgi.com>
		  Manfred Spraul <manfred@colorfullife.com>
		  Andi Kleen <andi@firstfloor.org>


