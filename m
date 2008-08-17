Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYHQIIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYHQIIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 04:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYHQIHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 04:07:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:49351 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbYHQIHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 04:07:51 -0400
Subject: Re: [Bug #11278] 2.6.27-rc2: Very odd top: '5124095h kthreadd'
	display
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Grant Coady <grant_lkml@dodo.com.au>
In-Reply-To: <sNRO-BDDjQL.A.i3F.PbzpIB@albercik>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
	 <sNRO-BDDjQL.A.i3F.PbzpIB@albercik>
Content-Type: text/plain
Date: Sun, 17 Aug 2008 10:07:49 +0200
Message-Id: <1218960469.10800.259.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-16 at 21:02 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11278
> Subject		: 2.6.27-rc2: Very odd top: '5124095h kthreadd' display
> Submitter	: Grant Coady <grant_lkml@dodo.com.au>
> Date		: 2008-08-07 7:03 (10 days old)
> References	: http://marc.info/?l=linux-kernel&m=121809267318795&w=4
> Handled-By	: Peter Zijlstra <peterz@infradead.org>


Should be fixed by: e26b33e9552c29c1d3fe67dc602c6264c29f5dc7

