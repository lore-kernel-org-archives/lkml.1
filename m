Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbYH3Ve4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbYH3Ve4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbYH3VZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:25:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58198 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757906AbYH3VZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:25:22 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
In-Reply-To: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <N8SeMoDzuxC.A.HDE.JibuIB@albercik>
Subject: [Bug #11435] oops due to smp_call_function_single changes
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 Aug 2008 21:50:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11435
Subject		: oops due to smp_call_function_single changes
Submitter	: Avi Kivity <avi@qumranet.com>
Date		: 2008-08-24 16:41 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=121959612027162&w=4


