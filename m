Return-Path: <linux-kernel-owner+w=401wt.eu-S1760299AbYFNVb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299AbYFNVb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbYFNVUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:20:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50376 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077AbYFNVUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:20:23 -0400
Cc: "tosn00j02@sneakemail.com <"@ogre.sisk.pl
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Jn7irxIunJK.A.77F.wMDVIB@albercik>
Subject: [Bug 9791] Clock is running too fast^Wslow using acpi_pm clocksource
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Jun 2008 22:12:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9791
Subject		: Clock is running too fast^Wslow using acpi_pm clocksource
Submitter	: tosn00j02@sneakemail.com
Date		: 2008-05-03 05:09 (43 days old)


