Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZDYWSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZDYWSP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZDYWR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:17:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41633 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZDYWR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:17:56 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
In-Reply-To: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Fg2zLW93smL.A._PF.5d48JB@chimera>
Subject: [Bug #13067] iwl3945: wlan0: beacon loss from AP - sending probe request
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Apr 2009 21:31:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13067
Subject		: iwl3945: wlan0: beacon loss from AP - sending probe request
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2009-04-05 9:11 (21 days old)
References	: http://marc.info/?l=linux-kernel&m=123892272218266&w=4
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=13067#c6


