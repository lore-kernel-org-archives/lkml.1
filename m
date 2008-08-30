Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbYH3Vcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbYH3Vcr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbYH3VZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:25:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58176 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758112AbYH3VZF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:25:05 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Joshua Hoblitt" <j_kernel@hoblitt.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
In-Reply-To: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <N8SeMoDzuxC.A.8uE.libuIB@albercik>
Subject: [Bug #11388] 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11388
Subject		: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Submitter	: Joshua Hoblitt <j_kernel@hoblitt.com>
Date		: 2008-08-20 17:38 (11 days old)


