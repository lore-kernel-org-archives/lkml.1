Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZDVUr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZDVUr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbZDVUrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:47:20 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57341 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbZDVUrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:47:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HOF1FZBIbmvkYlv3nKM727YwS+49+BXFgLrhwaWSJZd379Dzr/Mfdn7hewjnDF9GSM
         PUB3PKdez8TLpWRCArTuEDzxJK6qXhZakkwLMGdYHo8VdIso5QKaCnDgjV5bIpbPklWL
         SRoYQ9vP3/R5pimIYSu3yN+Lds3RSkd5MPRNI=
Message-ID: <49EF8214.20406@gmail.com>
Date: Wed, 22 Apr 2009 22:46:12 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, paulmck@linux.vnet.ibm.com,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       kaber@trash.net, jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v11)
References: <20090420103414.1b4c490f@nehalam> <49ECBE0A.7010303@cosmosbay.com> <18924.59347.375292.102385@cargo.ozlabs.ibm.com> <20090420215827.GK6822@linux.vnet.ibm.com> <18924.64032.103954.171918@cargo.ozlabs.ibm.com> <20090420160121.268a8226@nehalam> <alpine.LFD.2.00.0904210831560.2199@localhost.localdomain> <20090421111541.228e977a@nehalam> <20090421191007.GA15485@elte.hu> <49EE2293.4090201@cosmosbay.com> <20090422073524.GA31835@elte.hu> <49EEDAF0.2010507@cosmosbay.com> <alpine.LFD.2.00.0904220806320.3101@localhost.localdomain> <49EF4C75.6060604@cosmosbay.com> <alpine.LFD.2.00.0904221001270.3101@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904221001270.3101@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote, On 04/22/2009 07:18 PM:

...
> My problem today (apart from the relatively minor issue of also wanting to 
> get the commit log fixed up) is just that I see emails from you finding my 
> reaction shocking and from Jarek Poplawski that seem to still think that 
> I'm a troll.
> 
> Just because I pointed out real technical problems? Is that shocking or 
> trolling?

Very funny! For newbies only: http://en.wikipedia.org/wiki/Troll_(Internet)


Actually, I admit you could be the best "Ozzy" Osbourne imposter instead.
(At least at netdev.) Stephen's words seem to fit very well:
> Ah a nice day, with Linus giving constructive feedback. Too bad he has
> to channel it out of the dark side.

Jarek P.
