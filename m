Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbZE3Wjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbZE3Wjz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbZE3Wge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:36:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46520 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501AbZE3Wgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:36:32 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Miles Lane" <miles.lane@gmail.com>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
In-Reply-To: <4to6E2myxvG.A.muC.aIbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <LEcEO2518_I.A.6kD.zIbIKB@chimera>
Subject: [Bug #13373] fbcon, intelfb, i915: INFO: possible circular locking dependency detected
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:37:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13373
Subject		: fbcon, intelfb, i915: INFO: possible circular locking dependency detected
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-05-23 5:08 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=124305538130702&w=4


