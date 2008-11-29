Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbYK2Kz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbYK2Kz7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYK2Kzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:55:50 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:53737 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbYK2Kzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:55:49 -0500
Date: Sat, 29 Nov 2008 11:57:14 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq: sparseirq enabling v4
Message-ID: <20081129105714.GB9643@uranus.ravnborg.org>
References: <492A1877.4090304@kernel.org> <20081124144007.GA30725@elte.hu> <492B77C5.2050502@kernel.org> <20081126074826.GI26036@elte.hu> <492D02A4.4030206@kernel.org> <20081126081724.GK26036@elte.hu> <492E0540.9010009@kernel.org> <20081128163456.GB10487@elte.hu> <4930EB7F.1080307@kernel.org> <20081129100253.GD26691@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129100253.GD26691@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> very nice!
> 
> All the structural feedback i gave seems to be addressed properly, and 
> the patch has shrunk and consolidated nicely. I think we can start 
> splitting it up and applying it to tip/irq/sparseirq. We might notice a 
> few more details when that happens, on a per patch basis.

Hi Ingo / Yinghai.

Was the concerns raised by Benjamin, davem, others addressed?
Just curious - I have never looked into this part of the kernel.

	Sam
