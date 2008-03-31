Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYCaMvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYCaMvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 08:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYCaMvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 08:51:11 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:34494 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbYCaMvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 08:51:11 -0400
From: Chr <chunkeey@web.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Mon, 31 Mar 2008 14:51:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <200803302109.22219.chunkeey@web.de> <87wsnj8j2t.fsf@basil.nowhere.org>
In-Reply-To: <87wsnj8j2t.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803311451.08707.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX19pgLlbqk+viQyphLvctj4V0udH8tuo3wBBnU1D
	BvhB3V93mNagFmOLnMSlCSggrwQDFvzy39342gjvb/LMY1gqUm
	gDipgxiz8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 March 2008 09:10:34 Andi Kleen wrote:
> Chr <chunkeey@web.de> writes:
> > Ever since I went to the new 2.6.25-rcX, I encountered lots of random
> > system freezes after about 2 or 3 hours of uptime... but until now,
> > I couldn't _catch_ them, since the system
> > (AMD Athlon 4200+ X2 (Manchester) / nforce 4 SLI / x86_64) went
> > straight into oblivion (nothing on the serial console or anywhere else,
> > heck I couldn't even hit reset, It didn't POST anymore)
>
> Not POSTing would point to some kind of hardware problem. Normally
> the kernel shouldn't be able to cause that.
Normally yes.. but this is the first time that this ever happend!
(And my system has been stable so far (more than a year now, in fact more like 
2 years)... even with nvidia & madwifi drivers!). 

>
> I would recommend you double check if the problem is really not
> there with an older kernel by going back there and testing.
Well... older kernels won't freeze that way..
I can hit reset whenever I want and it still POSTs.

But, I'll try... maybe I get another change. 
(BTW, if it happends again, is there anything special, that
could help to find the real bugs?)
>
> -Andi
Regards,
	Chr.

