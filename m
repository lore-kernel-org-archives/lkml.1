Return-Path: <linux-kernel-owner+w=401wt.eu-S1760459AbYH3ViK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459AbYH3ViK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758509AbYH3VZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:25:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58235 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758486AbYH3VZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:25:55 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Greaves" <david@dgreaves.com>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
In-Reply-To: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <N8SeMoDzuxC.A.-VD.xhbuIB@albercik>
Subject: [Bug #11460] 2.6.27-rc3 to -rc4 regression: init 0 hangs in halt
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Aug 2008 21:50:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11460
Subject		: 2.6.27-rc3 to -rc4 regression: init 0 hangs in halt
Submitter	: David Greaves <david@dgreaves.com>
Date		: 2008-08-30 04:07 (1 days old)


