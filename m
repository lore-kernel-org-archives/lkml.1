Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbYGXTVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbYGXTVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYGXTVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:21:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45171 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbYGXTVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:21:39 -0400
Message-ID: <4888D631.8040401@garzik.org>
Date: Thu, 24 Jul 2008 15:21:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [build failure] hp-plus.c: (.text+0xd7c1a): undefined reference
 to `ei_close'
References: <20080721.233512.128618365.anemo@mba.ocn.ne.jp>	<20080721191519.GA15843@elte.hu>	<20080721214258.787a67ca@lxorguk.ukuu.org.uk>	<20080722072334.GA25241@elte.hu>	<48865899.3030209@garzik.org>	<20080723104520.GA20672@elte.hu>	<20080724052603.GA8744@elte.hu> <20080724100615.764bac36@lxorguk.ukuu.org.uk>
In-Reply-To: <20080724100615.764bac36@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 24 Jul 2008 07:26:03 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
>> not sure it's known but despite all the fixes i still get:
> 
> I'll have a look at this next week or possibly the week after. The
> original patches worked but they spent 3 months going round in circles
> and I've completely given up even trying to work out what happened or why
> all the previous updates I sent were ignored.

My apologies.  FWIW, from my point of view the same patch(es) kept 
getting fixed and updated and going around in circles, so I kept 
waiting.  Since it was was a net-next issue (until now), I lowered the 
priority and waited to let you guys (you, Andrew, Randy mainly) sort 
things out.

So far the only remaining patch I have outstanding and needing to be 
applied is from Atsushi-san via Ingo (message id 
<20080723104520.GA20672@elte.hu>)...  is that the last of it?

	Jeff


