Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYEaSwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYEaSwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 14:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbYEaSvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:51:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51379 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbYEaSvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:51:23 -0400
Cc: "Parag Warudkar" <parag.warudkar@gmail.com>,
       "Peter Zijlstra" <peterz@infradead.org>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
In-Reply-To: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <UJSav77TyUB.A.9MG.CuZQIB@albercik>
Subject: [Bug #10616] Horrendous Audio Stutter - current git
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 31 May 2008 19:48:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10616
Subject		: Horrendous Audio Stutter - current git
Submitter	: Parag Warudkar <parag.warudkar@gmail.com>
Date		: 2008-05-02 20:14 (30 days old)
References	: http://lkml.org/lkml/2008/5/1/440
		  http://lkml.org/lkml/2008/5/11/230
		  http://lkml.org/lkml/2008/5/18/178
Handled-By	: Peter Zijlstra <peterz@infradead.org>
Patch		: http://lkml.org/lkml/2008/5/2/126


