Return-Path: <linux-kernel-owner+w=401wt.eu-S1751490AbZKRFEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbZKRFEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 00:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbZKRFEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 00:04:50 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:33811 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZKRFEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 00:04:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=auG3Sg6H4pWgfPMvOXlIRtBlPFUjFA3kP9SlRRda5XefUOt7yE4zHe3QIuqxnpXGeV
         rM0EW3hTHzr3Qpp5CMJeRlmGiRTIitfcYrYAoURMuaxxFGx47YmtsPQnc/9MmZBOl8Nt
         nYmh93sZlRLMihD0WNWxPc5Xv+Kmv8n6kkhvc=
Message-ID: <4B03806F.7010803@gmail.com>
Date: Wed, 18 Nov 2009 00:04:47 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: huananhu@huawei.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/11]Optimize the upload speed for PPP connection.
References: <faf197be196ee.196eefaf197be@huawei.com>	<20091117.012248.86306050.davem@davemloft.net>	<4B0278D9.6030806@gmail.com> <20091117.034959.159359822.davem@davemloft.net>
In-Reply-To: <20091117.034959.159359822.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: William Allen Simpson <william.allen.simpson@gmail.com>
> Date: Tue, 17 Nov 2009 05:20:09 -0500
> 
>> What David may have meant, had he followed
>> Documentation/ManagementStyle or had any project management skills
>> what-so-ever, is that you need to follow
>> Documentation/SubmittingPatches more carefully.
> 
> Are personal attacks on me really necessary?
> 
Actually, ironic sarcasm (juxtaposition) is a form of humor, fairly
popular on such venues as "The Daily Show". :-)


> Do you want me to look closely at your patches with a high priority
> when you submit them for inclusion?
> 
Great, you're planning to start a new practice?  So far, I've only been
blessed with:

* 1st contact (Oct 2):

      "Otherwise asking for a is absolutely pointless as we have no
      context in which to judge the code you're showing us."

   The context (and entire previous patch) was pointed at by a link
   in the message, and an internet-draft, but that would have required
   effort (clicking and browsing).

   Not exactly what I'd call "look closely at your patches"....

* 2nd contact (Oct 5), replying to my post of Oct 3:

      "struct tcp_sock is already WAY TOO BIG on 64-bit systems, adding
      20 more bytes to it for some odd-ball feature is not something I'm
      willing to do, sorry."

   Always delighted to know our work is an "odd-ball feature"....

* 3rd contact, sending private email to you as maintainer, suggested by
   Andi Kleen's "On submitting kernel patches" for resolving conflicts,
   and getting flamed for sending private email to you!

* Recently, flamed for re-sending a query (after waiting 30 days):

      "Complaining that your work isn't getting looked at in a timely
      manner will always have the exact opposite effect that you want,
      it makes people have a smaller desire to look at your stuff."

   Yeah, 30 days just isn't long enough....  Fortunately, Eric Dumazet
   and Paul E. McKenney were really helpful (and others privately), and
   I thank them again!

* 2 days ago, flamed again for re-sending a patch (after waiting 5 days),
   although you'd never Ack'd or otherwise responded.


> You may be right, but that doesn't matter if you're interested in
> working together with me in the future.  There are diplomatic ways to
> do everything, and this wasn't one of those ways.
> 
Working *together* would be handy!  But that implies cooperation and
respect -- *not* biting the newbies nor dropping the F-bomb.

