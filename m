Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbXEIJAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbXEIJAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXEIJAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:00:10 -0400
Received: from main.gmane.org ([80.91.229.2]:33422 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbXEIJAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:00:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
Followup-To: gmane.linux.network
Date: Wed, 09 May 2007 10:58:06 +0200
Message-ID: <f1s2eu$26p$1@sea.gmane.org>
References: <464034CF.20700@wpkg.org> <f19298770705080148u70638ac2ue87241382681088@mail.gmail.com> <m3bqgv72sq.fsf@maximus.localdomain> <20070508155201.GA1251@xi.wantstofly.org> <m3hcqn5j0p.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 67.152.216.81.static.g-va.siw.siwnet.net
User-Agent: KNode/0.10.4
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Lennert Buytenhek <buytenh@wantstofly.org> writes:
>> There _is_ an ARM BE version of Debian.
>>
>> It's not an official port, but it's not maintained any worse than
>> the 'official' LE ARM Debian port is.

> Hmm... That changes a bit. Perhaps we should forget about
> that LE thing then, and (at best) put that trivial workaround?

Please keep in mind that users are unlikely to install an unofficial port
which lacks integration with the Debian infrastructure, security support
and other services. The arm architecture (LE) is currently the third most
popular in Debian, whereas I suspect (?) there are very few BE Debian
systems out there.

Marcus


