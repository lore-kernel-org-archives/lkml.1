Return-Path: <linux-kernel-owner+w=401wt.eu-S1423129AbXBBGRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423129AbXBBGRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 01:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423130AbXBBGRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 01:17:00 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:4921 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423129AbXBBGRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 01:17:00 -0500
Message-ID: <45C2D71A.8030209@jonmasters.org>
Date: Fri, 02 Feb 2007 01:15:54 -0500
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi[sz]ation Of Broken Dreams
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Trent Waddington <trent.waddington@gmail.com>,
       Tomas Carnecky <tom@dbservice.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Ban module license tag string termination trick
References: <Pine.LNX.4.61.0611011204140.23977@yvahk01.tjqt.qr>	 <Pine.LNX.4.61.0702012147470.1862@yvahk01.tjqt.qr>	 <45C2670F.5000003@jonmasters.org> <45C2832F.10603@dbservice.com>	 <3d57814d0702011651s5d5f9dafuc26369fab99ad5cf@mail.gmail.com> <1170385955.3073.884.camel@laptopd505.fenrus.org>
In-Reply-To: <1170385955.3073.884.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>>  But you're right, the MODULE_LICENSE tag really does imply that
>> licenses other than the GPL are ok.
> 
> yup.. BSD licensed modules are clearly ok as well..

So I guess we're going to go with Jan's change then.

I just wanted to discuss this briefly since I'm very keen for the kernel 
not to enforce legal/DRM type policy at all - this isn't quite the same 
discussion as we've had previously but the point remains: it should be 
for people to realize when they are violating a license as software 
unfortunately cannot ever be intelligent to catch all the baddies.

Personally, I am less worried if people use an obvious "PROPRIETARY" 
label because they're at least admitting and saying it how it is - then 
if later it can be shown that they are in fact violating kernel 
copyright, they've helped to sign their own death warrant :-)

Jon.
