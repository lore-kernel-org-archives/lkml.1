Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbYELHQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbYELHQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 03:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbYELHQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 03:16:39 -0400
Received: from www.tglx.de ([62.245.132.106]:49278 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbYELHQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 03:16:38 -0400
Date: Mon, 12 May 2008 09:16:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Bug #10623] k8-bus_64.c(?) spams dmesg in 2.6.26-rc1
In-Reply-To: <88YBFoyd1CN.A.Sh.ow1JIB@chimera>
Message-ID: <alpine.LFD.1.10.0805120915550.3514@apollo.tec.linutronix.de>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.Sh.ow1JIB@chimera>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2008, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10623
> Subject		: k8-bus_64.c(?) spams dmesg in 2.6.26-rc1
> Submitter	: Jeff Garzik <jeff@garzik.org>
> Date		: 2008-05-04 07:28 (8 days old)
> References	: http://lkml.org/lkml/2008/5/4/78
> Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>

fixed by: 0646153921892cc7a81320a6920beaca06b3e9f0

Thanks,
	tglx
