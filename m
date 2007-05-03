Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbXECUPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbXECUPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbXECUPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:15:47 -0400
Received: from terminus.zytor.com ([192.83.249.54]:44172 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbXECUPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:15:46 -0400
Message-ID: <463A42DF.5030409@zytor.com>
Date: Thu, 03 May 2007 13:15:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
       Albert Cahalan <acahalan@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
Subject: Re: console font limits
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com>  <Pine.LNX.4.64.0705011347300.27246@anakin> <1178021516.4372.62.camel@daplas> <46375738.1010007@zytor.com> <787b0d920705010849u52a4d6c3o2f1f800521ad5b95@mail.gmail.com> <Pine.LNX.4.61.0705021953030.18504@yvahk01.tjqt.qr>  <787b0d920705022317j485cbe26wc83f071834c53584@mail.gmail.com>  <Pine.LNX.4.61.0705030902430.18504@yvahk01.tjqt.qr> <787b0d920705030714k3b290d2csa38a5df63c692d6f@mail.gmail.com> <Pine.LNX.4.61.0705031621370.18504@yvahk01.tjqt.qr> <Pine.LNX.4.64.0705031754410.4727@anakin> <Pine.LNX.4.61.0705032020130.18504@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705032020130.18504@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
>> Put people didn't like that, and disabled text output when the console
>> is in KD_GRAPHICS mode...
> 
> at the cost of not getting the kernel oops, heh.
> 

I thought the reason we didn't display text in KD_GRAPHICS mode was that
KD_GRAPHICS might mean "in a completely different mode that only
userspace knows about."

	-hpa
