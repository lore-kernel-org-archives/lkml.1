Return-Path: <linux-kernel-owner+w=401wt.eu-S1759719AbYH3VgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719AbYH3VgN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758348AbYH3VZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:25:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58228 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758319AbYH3VZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:25:45 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alistair John Strachan" <alistair@devzero.co.uk>,
       "NeilBrown" <neilb@suse.de>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
In-Reply-To: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <N8SeMoDzuxC.A.ZdD.1hbuIB@albercik>
Subject: [Bug #11452] md (regression): reboot/shutdown hangs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Aug 2008 21:50:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11452
Subject		: md (regression): reboot/shutdown hangs
Submitter	: Alistair John Strachan <alistair@devzero.co.uk>
Date		: 2008-08-28 19:05 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=121995040514645&w=4


