Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbYFNVUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbYFNVUY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbYFNVTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:19:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50274 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbYFNVTq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:19:46 -0400
Cc: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Jn7irxIunJK.A.VkF.8KDVIB@albercik>
Subject: [Bug 10711] BUG: unable to handle kernel paging request - scsi_bus_uevent
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Jun 2008 22:12:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10711
Subject		: BUG: unable to handle kernel paging request - scsi_bus_uevent
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-05-14 11:23 (32 days old)
References	: http://lkml.org/lkml/2008/5/14/111


