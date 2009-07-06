Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbZGFX7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbZGFX7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbZGFX5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:57:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57860 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbZGFX5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:57:00 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Thomas Meyer" <thomas@m3y3r.de>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
In-Reply-To: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dWkuWjWDsSB.A.CAF.j0oUKB@chimera>
Subject: [Bug #13661] warning in smp_call_function_single while S2R
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 01:49:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13661
Subject		: warning in smp_call_function_single while S2R
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2009-06-27 17:12 (10 days old)
References	: http://lkml.org/lkml/2009/6/27/80


