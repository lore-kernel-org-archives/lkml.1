Return-Path: <linux-kernel-owner+w=401wt.eu-S932666AbZHYXjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbZHYXjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932536AbZHYXj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:39:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58660 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503AbZHYXf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:35:26 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mikael Pettersson" <mikpe@it.uu.se>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
In-Reply-To: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <_yaHeGjHEzG.A.tMH.9sGlKB@chimera>
Subject: [Bug #14015] pty regressed again, breaking expect and gcc's testsuite
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 25 Aug 2009 22:34:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14015
Subject		: pty regressed again, breaking expect and gcc's testsuite
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2009-08-14 23:41 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=125029329805643&w=4


