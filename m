Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZKPWzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZKPWzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbZKPWzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:55:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60299 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874AbZKPWy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:54:29 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Woodhouse" <david.woodhouse@intel.com>,
       "Michael" <schnitzelkuchen@googlemail.com>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A.vjF.ySdALB@chimera>
Subject: [Bug #14627] i915: *ERROR* Execbuf while wedged
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:37:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14627
Subject		: i915: *ERROR* Execbuf while wedged
Submitter	: Michael <schnitzelkuchen@googlemail.com>
Date		: 2009-11-15 10:48 (2 days old)
References	: http://lkml.org/lkml/2009/11/15/40


