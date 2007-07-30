Return-Path: <linux-kernel-owner+w=401wt.eu-S965921AbXG3Bd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965921AbXG3Bd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 21:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765911AbXG3Bdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 21:33:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:43235 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965650AbXG3Bdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 21:33:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=SLjbP3xTVOB3PwIt2jX/U/F5Q762iPytRCKzUVFm4bmrqc1qLqF/NM+mWJ9qXr1IaBRnntUiNmjLnJR5bDIqhLodffOwsAexSEI6C1hfAWO44pQBlB/LTQmgWtngfvaymshWhn1kSxh/PvecJrkZ6KINpREP/uxtdmR/PmzTGR8=
Message-ID: <46AD3EEE.8040007@googlemail.com>
Date: Mon, 30 Jul 2007 03:29:18 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org
Subject: Re: [PATCH] Make lguest compile with CONFIG_BLOCK=n and CONFIG_NET=n
References: <46ACAFBF.6060609@googlemail.com> <1185755123.12151.102.camel@localhost.localdomain>
In-Reply-To: <1185755123.12151.102.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Sun, 2007-07-29 at 17:18 +0200, Gabriel C wrote:
>> Hi Rusty,
>>
>> Lguest should depend on BLOCK too , without BLOCK set I get this error:
> 
> Hi Gabriel,
> 
> 	Thanks for the report!  It's probably better to fix this properly
> rather than hack it as I did for NET.
> 

You are welcome :)

Yes your solution is better :)


Gabriel
