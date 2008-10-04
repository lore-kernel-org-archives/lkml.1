Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYJDTUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYJDTUb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 15:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYJDTRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 15:17:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44639 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443AbYJDTRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:17:51 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Josh Boyer" <jwboyer@linux.vnet.ibm.com>
References: <0pOgGB.A.uLG.E475IB@wind>
In-Reply-To: <0pOgGB.A.uLG.E475IB@wind>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <yWwteD.A.jQB.u875IB@wind>
Subject: [Bug #11230] Kconfig no longer outputs a .config with freshly updated defconfigs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  4 Oct 2008 19:32:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11230
Subject		: Kconfig no longer outputs a .config with freshly updated defconfigs
Submitter	: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date		: 2008-08-02 16:03 (64 days old)
References	: http://marc.info/?l=linux-kernel&m=121769306319391&w=4


