Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYAOHNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYAOHNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 02:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYAOHNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 02:13:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:49380 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbYAOHNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 02:13:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=tT9JKcMSAH4m2njmqMMd9zokYRLiySFTndzN28Txc/T48Gku66Gm7FKEDdHQI//WsAvXra0FGpCPjd8UZSDOyFomI0u1u3oIMEwPyZopvCmSbAdFtHvfDaiCPNH+18sq+YFqvbXUD0j1yjhSZeIy1P9Daxq9xU/JAwAkPzZCNn0=
Date: Tue, 15 Jan 2008 08:19:50 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network
	packets
Message-ID: <20080115071950.GA1696@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478B86BA.1050706@nortel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-01-2008 16:58, Chris Friesen wrote:
...
> How close to bleeding edge do we need to be for it to be considered 
> acceptable to ask questions on netdev?
> 
> Given that the embedded space tends to be perpetually stuck on older 
> kernels (our "current" release is based on 2.6.14) do you have any 
> suggestion on how we can obtain information that would be available on 
> netdev if we were using newer kernels?

IMHO, checking this with a current stable, which probably you are going
to do some day, anyway, should be 100% acceptable: giving some input to
netdev, while still working for yourself.

Regards,
Jarek P.
