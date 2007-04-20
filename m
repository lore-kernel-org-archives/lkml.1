Return-Path: <linux-kernel-owner+w=401wt.eu-S1767094AbXDTN0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767094AbXDTN0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 09:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767096AbXDTN0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 09:26:10 -0400
Received: from 85-126-107-146.static.sdsl-line.inode.at ([85.126.107.146]:4760
	"EHLO mail.contec.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767094AbXDTN0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 09:26:09 -0400
From: Manfred Gruber <m.gruber@tirol.com>
To: linux-kernel@vger.kernel.org
Subject: Re: preempt_rt bug or warn on arm v4t
Date: Fri, 20 Apr 2007 15:26:40 +0200
User-Agent: KMail/1.6.2
References: <200704201306.08066.m.gruber@tirol.com> <1177074102.3636.49.camel@localhost.localdomain>
In-Reply-To: <1177074102.3636.49.camel@localhost.localdomain>
Cc: tglx@linutronix.de, mingo@elte.hu
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200704201526.40785.m.gruber@tirol.com>
X-OriginalArrivalTime: 20 Apr 2007 13:26:06.0359 (UTC) FILETIME=[734F7270:01C7834F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi jan !

Am Freitag, 20. April 2007 15:01 schrieben Sie:

> > I am using 2.6.21-rc7 with Preempt_rt Patch 2.6.20-rc6-rt0 on ep93xx.
>
> Do you mean 2.6.21-rc6-rt0?

sorry yes 2.6.21-rc6-rt0.

> > This oops does not trigger in preempt_rt patch is applied.
>
> It does only appear, when the preempt_rt patch is applied. Did I get you
> right?

correct

regards manfred
