Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYEaSva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYEaSva (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 14:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYEaSvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:51:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51368 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbYEaSvV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:51:21 -0400
Cc: "NIgel Cunningham" <nigel@suspend2.net>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
In-Reply-To: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <UJSav77TyUB.A.QcG.QuZQIB@albercik>
Subject: [Bug #10606] 2.6.26-rc1 regression: ACPI fails to load SDT. - Dell M1530
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 31 May 2008 19:48:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10606
Subject		: 2.6.26-rc1 regression: ACPI fails to load SDT. - Dell M1530
Submitter	: NIgel Cunningham <nigel@suspend2.net>
Date		: 2008-05-05 18:11 (27 days old)
References	: http://lkml.org/lkml/2008/5/18/328
		  http://lkml.org/lkml/2008/5/26/3
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=16061&amp;action=view


