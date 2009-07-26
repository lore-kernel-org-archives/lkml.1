Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZGZXk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZGZXk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbZGZXfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:35:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58831 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbZGZXfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:35:52 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rus" <harbour@sfinx.od.ua>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
In-Reply-To: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <H5-1lZIIeYK.A.P_G.pXObKB@chimera>
Subject: [Bug #13514] acer_wmi causes stack corruption
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:45:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13514
Subject		: acer_wmi causes stack corruption
Submitter	: Rus <harbour@sfinx.od.ua>
Date		: 2009-06-12 08:13 (45 days old)


