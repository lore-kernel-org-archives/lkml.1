Return-Path: <linux-kernel-owner+w=401wt.eu-S1759879AbYH3Vdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879AbYH3Vdb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757649AbYH3VZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:25:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58181 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757679AbYH3VZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:25:08 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Frans Pop" <elendil@planet.nl>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
In-Reply-To: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <N8SeMoDzuxC.A.2nE.hibuIB@albercik>
Subject: [Bug #11398] hda_intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Aug 2008 21:50:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11398
Subject		: hda_intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-08-21 17:17 (10 days old)


