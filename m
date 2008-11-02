Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYKBSEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYKBSEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbYKBSBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:01:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35645 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521AbYKBSBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:01:40 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
In-Reply-To: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wOAXuecskPD.A.dhG.lkeDJB@chimera>
Subject: [Bug #11854] v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to userspace
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Nov 2008 17:07:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11854
Subject		: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to userspace
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-10-25 17:14 (9 days old)
References	: http://marc.info/?l=linux-kernel&m=122495490201663&w=4


