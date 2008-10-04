Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbYJDT1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbYJDT1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 15:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYJDTTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 15:19:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44725 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796AbYJDTTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:19:10 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Duncan" <1i5t5.duncan@cox.net>
References: <0pOgGB.A.uLG.E475IB@wind>
In-Reply-To: <0pOgGB.A.uLG.E475IB@wind>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <yWwteD.A.I0G.d475IB@wind>
Subject: [Bug #11676] 2.6.27-rc2 to rc8, apgart fails, iommu=soft works, regression
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  4 Oct 2008 19:32:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11676
Subject		: 2.6.27-rc2 to rc8, apgart fails, iommu=soft works, regression
Submitter	: Duncan <1i5t5.duncan@cox.net>
Date		: 2008-09-30 10:24 (5 days old)


