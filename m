Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbYLaIc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbYLaIc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYLaIcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:32:47 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:23686 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbYLaIcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:32:47 -0500
X-Greylist: delayed 35178 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Dec 2008 03:32:46 EST
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: :I2ANY0W6W/eA95XfH/xfO6gOxLxTty/udEMngcJ/VAKW226lDNJVyuUMITI/P7ox
Message-ID: <495B2E27.4020704@hartkopp.net>
Date: Wed, 31 Dec 2008 09:32:39 +0100
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH] hrtimer: removing all ur callback modes
References: <1227613431.4259.1537.camel@twins> <1228385830.5092.43.camel@twins> <493BB1EB.5000004@hartkopp.net> <493BC8A8.2030200@hartkopp.net> <1228731359.5778.18.camel@twins> <493E2725.7090305@hartkopp.net> <1228810331.12729.59.camel@twins> <20081209105902.GB21618@elte.hu> <495AA4BB.8020903@hartkopp.net>
In-Reply-To: <495AA4BB.8020903@hartkopp.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Hartkopp wrote:
>
> AFAICS the commit ca109491f612aab5c8152207631c0444f63da97f
>
> "hrtimer: removing all ur callback modes" with "Impact: cleanup, move 
> all hrtimer processing into hardirq context"
>
> did not find it's way into linux-2.6.git - is there any reason for this?

Just seen it has been pulled half an hour after my mail ... sorry for 
the noise.

Thanks,
Oliver

