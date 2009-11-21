Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbZKUPMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbZKUPMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbZKUPMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:12:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58657 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226AbZKUPHx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:07:53 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eero Nurkkala" <ext-eero.nurkkala@nokia.com>,
       "john stultz" <johnstul@us.ibm.com>, "Thibault Mondary" <thibm@free.fr>
References: <pohDdrcORVG.A.U2B.-6_BLB@chimera>
In-Reply-To: <pohDdrcORVG.A.U2B.-6_BLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <l2_yP_tdgYK.A.MZD.57_BLB@chimera>
Subject: [Bug #14426] CE: hpet increasing min_delta_ns flood
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Nov 2009 15:51:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14426
Subject		: CE: hpet increasing min_delta_ns flood
Submitter	: Thibault Mondary <thibm@free.fr>
Date		: 2009-10-17 09:29 (36 days old)


