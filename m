Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbYH3V01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbYH3V01 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbYH3VYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:24:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58095 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbYH3VYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:24:03 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Hugh Dickins" <hugh@veritas.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
In-Reply-To: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <N8SeMoDzuxC.A.kUG.jkbuIB@albercik>
Subject: [Bug #11237] corrupt PMD after resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Aug 2008 21:50:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
Subject		: corrupt PMD after resume
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-08-02 9:51 (29 days old)
References	: http://marc.info/?l=linux-kernel&m=121767073424952&w=4
Handled-By	: Hugh Dickins <hugh@veritas.com>
		  Jeremy Fitzhardinge <jeremy@goop.org>


