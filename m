Return-Path: <linux-kernel-owner+w=401wt.eu-S1767455AbXCISZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767455AbXCISZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 13:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767454AbXCISZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 13:25:14 -0500
Received: from Mail.MNSU.EDU ([134.29.1.12]:54777 "EHLO mail.mnsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767455AbXCISZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 13:25:12 -0500
Message-ID: <45F1A65D.5000903@mnsu.edu>
Date: Fri, 09 Mar 2007 12:24:29 -0600
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Con Kolivas <kernel@kolivas.org>,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       William Lee Irwin III <wli@holomorphy.com>,
       Matt Mackall <mpm@selenic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
References: <20070309053931.GA10459@waste.org>	<200703091728.03978.kernel@kolivas.org>	<20070309075358.GA10394@waste.org>	<200703091936.47128.kernel@kolivas.org>	<87slce945h.fsf@depni.sinp.msu.ru>	<20070309094904.GC2986@holomorphy.com> <87irdasnz4.fsf@depni.sinp.msu.ru> <45F1A263.5020407@rtr.ca>
In-Reply-To: <45F1A263.5020407@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Mark Lord wrote:
> Mmm.. when it's good, it's *really* good.
> My desktop feels snappier and all of that.
>
> No noticeable jerkiness of windows/scrolling,
> which I *do* observe with the stock scheduler.
>
> But when it's bad, it stinks.
> Like when a "make -j2" kernel rebuild is happening in a background window
>

Would you please do that same "make -j2" niced.  Tell us how that feels.

-- 
Jeffrey Hundstad

