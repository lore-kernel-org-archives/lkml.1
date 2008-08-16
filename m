Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYHPWif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYHPWif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 18:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYHPWiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 18:38:15 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:40028 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145AbYHPWiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 18:38:13 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [Bug #11278] 2.6.27-rc2: Very odd top: '5124095h kthreadd' display
Date: Sun, 17 Aug 2008 08:37:55 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <hklea496mukvmcee8ruvls6q8er55029ue@4ax.com>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.i3F.PbzpIB@albercik>
In-Reply-To: <sNRO-BDDjQL.A.i3F.PbzpIB@albercik>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008 21:02:51 +0200 (CEST), "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

>This message has been generated automatically as a part of a report
>of recent regressions.
>
>The following bug entry is on the current list of known regressions
>from 2.6.26.  Please verify if it still should be listed and let me know
>(either way).
>
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11278
>Subject		: 2.6.27-rc2: Very odd top: '5124095h kthreadd' display
>Submitter	: Grant Coady <grant_lkml@dodo.com.au>
>Date		: 2008-08-07 7:03 (10 days old)
>References	: http://marc.info/?l=linux-kernel&m=121809267318795&w=4
>Handled-By	: Peter Zijlstra <peterz@infradead.org>
>
The problem is not evident in 2.6.27-rc3

Grant.
