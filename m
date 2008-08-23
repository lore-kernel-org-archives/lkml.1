Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYHWW0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYHWW0m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 18:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbYHWW0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 18:26:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44352 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbYHWW0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 18:26:34 -0400
Message-ID: <48B08E94.8030805@garzik.org>
Date: Sat, 23 Aug 2008 18:26:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jaswinder Singh <jaswinderlinux@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: [Bug #11271] BUG: fealnx in 2.6.27-rc1
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.U-.FcGsIB@albercik>
In-Reply-To: <VSpL6AnBTS.A.U-.FcGsIB@albercik>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11271
> Subject		: BUG: fealnx in 2.6.27-rc1
> Submitter	: Jaswinder Singh <jaswinderlinux@gmail.com>
> Date		: 2008-08-05 14:58 (19 days old)
> References	: http://marc.info/?l=linux-netdev&m=121794762016830&w=4
> 		  http://lkml.org/lkml/2008/8/10/98
> Handled-By	: Francois Romieu <romieu@fr.zoreil.com>


Jaswinder, does reverting 28cd4289abc2c8db90344ee4ff064a9bdf086fdf help?

That's the only material change to fealnx itself in years.

If not, any chance you could bisect this problem, and add more info to 
the bug?

