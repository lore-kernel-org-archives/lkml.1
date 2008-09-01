Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbYIAHTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbYIAHTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 03:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYIAHTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 03:19:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:13315 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbYIAHTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 03:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=StmCwzEEA6Px/csbUBqFNYNji9WELFZo6nIPZktMttWsTJR8kG2ubEr7oULWIlEO/b
         zlQLbKKNP0MRu9B69/kEtk8LN3bi1V9jiiqQn7vOsNEjiOYm0zfSCBrBXLJZLNYK15mn
         DNjvdCqzWbpyz/wCZi3/21pla8skMsgPw4lvE=
Message-ID: <40f31dec0809010019x54d14f43ub614f98ec6420ad7@mail.gmail.com>
Date: Mon, 1 Sep 2008 10:19:05 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [GIT]: Networking
Cc: "Rui Santos" <rsantos@grupopie.com>, "Ivo van Doorn" <ivdoorn@gmail.com>,
       "David Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808311313260.12958@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080805.190020.244441681.davem@davemloft.net>
	 <alpine.LFD.1.10.0808051937410.15995@nehalem.linux-foundation.org>
	 <200808061021.56150.IvDoorn@gmail.com> <48B7CBA7.4060107@grupopie.com>
	 <40f31dec0808311258q7598dfe3he81b7575375faff5@mail.gmail.com>
	 <alpine.LFD.1.10.0808311313260.12958@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/31 Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Sun, 31 Aug 2008, Nick Kossifidis wrote:
>>
>> EeePC is working, the patch series i submitted adds support for RF2425
>> chip which is included on EeePCs as far as i know (i have tested it on
>> an EeePC 900 surf, i think EeePC 901 has the same card) ;-)
>
> I think the EeePC 900 has a ath5k chip, and the 901/1000 has some totally
> different RaLink chip afaik.
>
> I think the design change came when moving from Celeron to Atom.
>
>                Linus
>

Hmm i missed that part, sorry for the spam...

01:00.0 Network controller: RaLink Unknown device 0781

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
