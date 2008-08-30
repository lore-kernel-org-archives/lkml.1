Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbYH3V0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbYH3V0D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbYH3VX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:23:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58093 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539AbYH3VX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:23:57 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Brice Goglin" <brice@myri.com>, "Martin Michlmayr" <tbm@cyrius.com>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
In-Reply-To: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <N8SeMoDzuxC.A.dpF.TjbuIB@albercik>
Subject: [Bug #11334] myri10ge: use ioremap_wc: compilation failure on ARM
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Aug 2008 21:50:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11334
Subject		: myri10ge: use ioremap_wc: compilation failure on ARM
Submitter	: Martin Michlmayr <tbm@cyrius.com>
Date		: 2008-08-10 11:25 (21 days old)
References	: http://marc.info/?l=linux-netdev&m=121836771727632&w=2


