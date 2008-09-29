Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYI2JT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYI2JT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYI2JTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:19:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58049 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbYI2JTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:19:49 -0400
Date: Mon, 29 Sep 2008 11:19:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: merge winchip-2 and winchip-2a cpu choices
Message-ID: <20080929091908.GA7735@elte.hu>
References: <20080928212815.6ffea9d9.krzysztof.h1@wp.pl> <48E09AE9.3090501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E09AE9.3090501@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Looks good to me.
>
> Acked-by: H. Peter Anvin <hpa@zytor.com>
>
> Krzysztof Helt wrote:
>> From: Krzysztof Helt <krzysztof.h1@wp.pl>
>>
>> The Winchip-2 and Winchip-2A cpu choices select the
>> same options for kernel and compiler. 
>>
>> Merge them to save few bytes and reduce confusion.
>>
>> Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>

applied to tip/x86/core, thanks Krzysztof!

(I left out the UML defconfig update - that can be done later and it 
doesnt hurt anyway.)

	Ingo
