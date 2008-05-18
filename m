Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbYERRXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbYERRXD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 13:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbYERRVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 13:21:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49003 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759384AbYERRVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 13:21:33 -0400
Subject: Re: [Bug #10616] Horrendous Audio Stutter - current git
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Parag Warudkar <parag.warudkar@gmail.com>
In-Reply-To: <7wuznNhcUqC.A.81B.-tBMIB@albercik>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	 <7wuznNhcUqC.A.81B.-tBMIB@albercik>
Content-Type: text/plain
Date: Sun, 18 May 2008 19:21:27 +0200
Message-Id: <1211131287.6463.8.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-18 at 13:13 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10616
> Subject		: Horrendous Audio Stutter - current git
> Submitter	: Parag Warudkar <parag.warudkar@gmail.com>
> Date		: 2008-05-02 20:14 (17 days old)
> References	: http://lkml.org/lkml/2008/5/1/440
> 		  http://lkml.org/lkml/2008/5/11/230
> Handled-By	: Peter Zijlstra <peterz@infradead.org>
> Patch		: http://lkml.org/lkml/2008/5/2/126

Could people test this:

git://git.kernel.org/home/peterz/git/linux-2.6-sched.git/ v2.6.26-rc2-group-load-balance

