Return-Path: <linux-kernel-owner+w=401wt.eu-S934133AbXGKWRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934133AbXGKWRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763053AbXGKWR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:17:28 -0400
Received: from [212.12.190.144] ([212.12.190.144]:32998 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764176AbXGKWR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:17:28 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE][RFC] PlugSched-6.5.1 for  2.6.22
Date: Thu, 12 Jul 2007 01:17:20 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707120117.20405.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Williams wrote:
>
> Probably the last one now that CFS is in the main line :-(.

What do you mean?  A pluggable scheduler framework is indispensible even in 
the presence of CFS or SD.

> A patch for 2.6.22 is available at:
>
> <http://downloads.sourceforge.net/cpuse/plugsched-6.5.1-for-2.6.22.patch>
>
> Very Brief Documentation:
>
> You can select a default scheduler at kernel build time.  If you wish to
> boot with a scheduler other than the default it can be selected at boot
> time by adding:
>
> cpusched=<scheduler>
>
> to the boot command line where <scheduler> is one of: ingosched,
> ingo_ll, nicksched, staircase, spa_no_frills, spa_ws, spa_svr, spa_ebs
> or zaphod.  If you don't change the default when you build the kernel
> the default scheduler will be ingosched (which is the normal scheduler).

Can't PlugSched include CFS and SD?


Thanks!

--
Al

