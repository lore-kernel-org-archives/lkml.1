Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbXGPXCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbXGPXCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbXGPXCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:02:23 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:52350 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbXGPXCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:02:22 -0400
Message-ID: <469BF8C5.40601@gmail.com>
Date: Tue, 17 Jul 2007 01:01:25 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <8FO1e-2jW-35@gated-at.bofh.it> <8Gj55-hJ-5@gated-at.bofh.it>	 <8GkNo-2Vb-1@gated-at.bofh.it> <8GtnN-7TG-23@gated-at.bofh.it>	 <8GVjY-PL-25@gated-at.bofh.it> <E1IA7j1-0000j9-I3@be1.lrz>	 <469A5D7C.5010904@gmail.com>	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>	 <469BF104.1040703@gmail.com>	 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <9a8748490707161554j1fa7625fq1f1cb7e6aa359715@mail.gmail.com>
In-Reply-To: <9a8748490707161554j1fa7625fq1f1cb7e6aa359715@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2007 12:54 AM, Jesper Juhl wrote:

> Please note that I was not trying to remove the 8K stack option right
> now - heck, I didn't even add anything to feature-removal-schedule.txt
> - all I wanted to accomplish with the patch that started this threas
> was;  a) indicate that the 4K option is no longer a debug thing  and
> b) make 4K stacks the default option in vanilla kernel.org kernels as
> a gentle nudge towards getting people to start fixing the code paths
> that are not 4K stack safe.

Definite Acked-by: Rene Herman <rene.herman@gmail.com> where others can 
decide what that ack's worth.

Rene.
