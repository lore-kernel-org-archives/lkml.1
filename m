Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbXEQJ03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbXEQJ03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXEQJ0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:26:22 -0400
Received: from mail22.syd.optusnet.com.au ([211.29.133.160]:37276 "EHLO
	mail22.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753965AbXEQJ0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:26:21 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org
Subject: Re: [ck] Swap prefetch tester
Date: Thu, 17 May 2007 19:26:03 +1000
User-Agent: KMail/1.9.5
Cc: "Kacper Wysocki" <kacperw@online.no>, linux-kernel@vger.kernel.org
References: <200705141210.43614.kernel@kolivas.org> <200705141217.57142.kernel@kolivas.org> <367a23780705151304s49734da1u778ab1ea96b3e9ed@mail.gmail.com>
In-Reply-To: <367a23780705151304s49734da1u778ab1ea96b3e9ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171926.04165.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007 06:04, Kacper Wysocki wrote:
> ...a nice order of magnitude better! Very happy you fixed this Con.

Great!, thanks for testing.

> Have I understood correctly that there are more prefetch improvements
> in ck2 than just the sp38 patch?

No; 2.6.21-ck2 simply brings it up to sp38. The code in -ck for swap prefetch 
is a little different to suit the SD scheduler and the SCHED_IDLEPRIO patch.
>
> I'll post more results if I ever manage to tear myself from the
> computer for 10 minutes when I'm home - it looks like I have a yiff
> daemon running at 7% cpu all the time which might have affected the
> results.
>
> Speaking of "feel", the net effect of swap prefetch for me seems to be
> that I don't notice it - that is, I don't notice my programs behaving
> sluggishly when I come back to the computer. Excellent!

Excellent!. Thanks very much for your feedback.

-- 
-ck
