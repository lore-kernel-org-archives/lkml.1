Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbXIOKgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbXIOKgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 06:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbXIOKgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 06:36:17 -0400
Received: from mythwiki.de ([85.214.77.21]:38858 "EHLO
	h1079978.serverkompetenz.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbXIOKgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 06:36:17 -0400
Message-ID: <46EBB59E.40206@laga.ath.cx>
Date: Sat, 15 Sep 2007 12:36:14 +0200
From: Michael Haas <laga@laga.ath.cx>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Subject: Re: Problem: screen partially garbled in i830m (regression)
References: <46E7D5AD.7040605@laga.ath.cx> <Pine.LNX.4.64.0709121508240.12658@skynet.skynet.ie>
In-Reply-To: <Pine.LNX.4.64.0709121508240.12658@skynet.skynet.ie>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
>> reply so far, that's why I'm posting to LKML this time.  Short summary:
>> 874808c6dd429f7431b906a32c7f78a68e7636af broke intel_agp.ko for me, I'm
>> getting a garbled screen.
> 
> Can you try the attached patch?
> 

Hello David,

I haven't been able to try your patch yet. However, two nice people from
the zenega-user forum ("hemonu" and "scythe") tried the patch. It fixed
the garbled screen problem for them.

If that's not good enough for you or if you need additional information,
I can try it myself.

Thanks for your prompt reply!

Michael
