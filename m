Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZJSH6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZJSH6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZJSH6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:58:22 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59086 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538AbZJSH6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:58:21 -0400
Date: Mon, 19 Oct 2009 09:58:25 +0200
From: Sebastian Andrzej Siewior <bigeasy@breakpoint.cc>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] consider stack access while checking for alternate
 signal stack
Message-ID: <20091019075824.GA25783@Chamillionaire.breakpoint.cc>
References: <20091018191247.GA21844@Chamillionaire.breakpoint.cc>
 <20091019130931.6d8f0340@hskinnemoen-d830>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091019130931.6d8f0340@hskinnemoen-d830>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Haavard Skinnemoen | 2009-10-19 13:09:31 [+0900]:

>Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:
>> Haavard: The AVR32 assumption is pure on gcc's STACK_PUSH_CODE which is
>> POST_DEC. Could you please ack/nak it?
>
>Hmm, no, that is not correct. AVR32 is definitely pre-decrement.
>
>Note that 8-bit AVR and AVR32 are two completely different
>architectures.
Ah okay. So the AVR32 bits are not in upstream GCC yet?

>
>Haavard

Sebastian
