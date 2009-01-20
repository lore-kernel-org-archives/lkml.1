Return-Path: <linux-kernel-owner+w=401wt.eu-S1762800AbZATA34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762800AbZATA34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbZATA3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:29:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63643 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbZATA3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:29:45 -0500
Message-ID: <49751AF2.5050401@cn.fujitsu.com>
Date: Tue, 20 Jan 2009 08:29:38 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12419] possible circular locking dependency on i915 dma
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera> <2QN7KFic7LG.A.mK.89QdJB@chimera>
In-Reply-To: <2QN7KFic7LG.A.mK.89QdJB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki said the following on 2009-1-20 5:32:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12419
> Subject		: possible circular locking dependency on i915 dma
> Submitter	: Wang Chen <wangchen@cn.fujitsu.com>
> Date		: 2009-01-08 14:11 (12 days old)
> References	: http://marc.info/?l=linux-kernel&m=123142399720125&w=4
> 

This regression is still there in mainline.

