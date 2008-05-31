Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbYEaTCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbYEaTCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 15:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbYEaSvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:51:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51430 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbYEaSvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:51:35 -0400
Cc: =?utf-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "Ingo Molnar" <mingo@elte.hu>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
In-Reply-To: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <UJSav77TyUB.A.rFD.sqZQIB@albercik>
Subject: [Bug #10823] stuck localhost TCP connections, v2.6.26-rc3+
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 31 May 2008 19:48:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10823
Subject		: stuck localhost TCP connections, v2.6.26-rc3+
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2008-05-26 11:56 (6 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121180311931349&amp;w=4
Handled-By	: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>


