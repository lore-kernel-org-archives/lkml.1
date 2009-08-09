Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbZHJAMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbZHJAMc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 20:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbZHJAFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 20:05:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44127 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbZHJAFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 20:05:50 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Joao Correia" <joaomiguelcorreia@gmail.com>
References: <YCu3FOC0QrC.A.MaE.RD2fKB@chimera>
In-Reply-To: <YCu3FOC0QrC.A.MaE.RD2fKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pRuaDVjxFBG.A._CF.-D2fKB@chimera>
Subject: [Bug #13660] Crashes during boot on 2.6.30 / 2.6.31-rc, random programs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Aug 2009 23:10:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13660
Subject		: Crashes during boot on 2.6.30 / 2.6.31-rc, random programs
Submitter	: Joao Correia <joaomiguelcorreia@gmail.com>
Date		: 2009-06-27 16:07 (44 days old)
References	: http://lkml.org/lkml/2009/6/27/95


