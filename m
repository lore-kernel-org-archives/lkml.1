Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZHZAFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZHZAFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbZHZAFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:05:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58956 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343AbZHZAFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:05:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>
References: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
In-Reply-To: <JuOd1ZASH0B.A.YGB.0zGlKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Cg6cQYLdUxG.A.f2B.l0GlKB@chimera>
Subject: [Bug #13646] warn_on tty_io.c, broken bluetooth
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 25 Aug 2009 23:05:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13646
Subject		: warn_on tty_io.c, broken bluetooth
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-06-19 17:05 (68 days old)
References	: http://lkml.org/lkml/2009/6/19/187


