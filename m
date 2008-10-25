Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbYJYXHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbYJYXHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 19:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbYJYXAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 19:00:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52169 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587AbYJYXAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 19:00:47 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Antipov Dmitry" <dmantipov@yandex.ru>,
       "Jordan Crouse" <jordan.crouse@amd.com>
References: <3ZqdCuOdOqB.A.EPE.fJ6AJB@chimera>
In-Reply-To: <3ZqdCuOdOqB.A.EPE.fJ6AJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <gLTYxg3cC1.A.1zE.vJ6AJB@chimera>
Subject: [Bug #11820] 2.6.27: 0 MHz CPU and wrong system time on AMD Geode system
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Oct 2008 23:07:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11820
Subject		: 2.6.27: 0 MHz CPU and wrong system time on AMD Geode system
Submitter	: Antipov Dmitry <dmantipov@yandex.ru>
Date		: 2008-10-15 6:39 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=122405421010969&w=4
Handled-By	: Jordan Crouse <jordan.crouse@amd.com>


