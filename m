Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbYHWTw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbYHWTw4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbYHWTnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:43:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50188 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830AbYHWTnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:43:01 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Vrabel" <david.vrabel@csr.com>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
In-Reply-To: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <VSpL6AnBTS.A.WJH.aaGsIB@albercik>
Subject: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 23 Aug 2008 20:10:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11382
Subject		: e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Submitter	: David Vrabel <david.vrabel@csr.com>
Date		: 2008-08-08 10:47 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=121819267211679&w=4


