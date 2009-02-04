Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbZBDNFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbZBDNFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbZBDMvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:51:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45085 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbZBDMvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:51:06 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ira Snyder" <iws@ovro.caltech.edu>,
       "Peter Korsgaard" <jacmet@sunsite.dk>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
In-Reply-To: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pWZw1SZjMCH.A.2aD.muYiJB@chimera>
Subject: [Bug #12615] boot hangs while bringing up gianfar ethernet
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:24:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12615
Subject		: boot hangs while bringing up gianfar ethernet
Submitter	: Ira Snyder <iws@ovro.caltech.edu>
Date		: 2009-01-29 19:41 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=123325817201665&w=4


