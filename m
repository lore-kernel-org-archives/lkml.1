Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbYK2RxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbYK2RxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 12:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYK2RxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 12:53:06 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:42413 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYK2RxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 12:53:05 -0500
Date: Sat, 29 Nov 2008 18:54:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq: sparseirq enabling v4
Message-ID: <20081129175427.GA15456@uranus.ravnborg.org>
References: <492B77C5.2050502@kernel.org> <20081126074826.GI26036@elte.hu> <492D02A4.4030206@kernel.org> <20081126081724.GK26036@elte.hu> <492E0540.9010009@kernel.org> <20081128163456.GB10487@elte.hu> <4930EB7F.1080307@kernel.org> <20081129100253.GD26691@elte.hu> <20081129105714.GB9643@uranus.ravnborg.org> <20081129143327.GB10639@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129143327.GB10639@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 03:33:27PM +0100, Ingo Molnar wrote:
> 
> I cannot speak for them, but my concens have been addressed. AFAICT the 
> feedback from non-x86 land centered around two main areas:
> 
....
Hi Ingo,

    thanks for a nice summary.

	Sam
