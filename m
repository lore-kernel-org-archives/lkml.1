Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbYHJAh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbYHJAh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 20:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYHJAhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 20:37:51 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:36278 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753347AbYHJAhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 20:37:51 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11278] 2.6.27-rc2: Very odd top: '5124095h kthreadd' display
Date: Sun, 10 Aug 2008 10:37:29 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <otds94lkpmrooo1s9c0he3j3pral8fmojl@4ax.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.WR.xCjnIB@albercik>
In-Reply-To: <cX_-nNkxKaF.A.WR.xCjnIB@albercik>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2008 00:43:52 +0200 (CEST), "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

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
>Date		: 2008-08-07 7:03 (3 days old)
>References	: http://marc.info/?l=linux-kernel&m=121809267318795&w=4
>

Patch from Peter Z. fixed it for me, so it may be removed now.

Grant.
