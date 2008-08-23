Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbYHWT5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbYHWT5H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbYHWTnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:43:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50235 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbYHWTnj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:43:39 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Daniel J Blueman" <daniel.blueman@gmail.com>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
In-Reply-To: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <VSpL6AnBTS.A.vJG.5ZGsIB@albercik>
Subject: [Bug #11410] SLUB list_lock vs obj_hash.lock...
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 23 Aug 2008 20:10:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11410
Subject		: SLUB list_lock vs obj_hash.lock...
Submitter	: Daniel J Blueman <daniel.blueman@gmail.com>
Date		: 2008-08-22 21:48 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121944176609042&w=4


