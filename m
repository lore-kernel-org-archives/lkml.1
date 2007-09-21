Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbXIURET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbXIURET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbXIUREG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:04:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:39270 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbXIURED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:04:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=mHE1P5qzutWGiyVvDcVWsNjSgEf4X0AvYpYZhpp8qDfAd6FRt9a14BwO6y8g2li9aMEbBqBPXhkw7FKoWqxE/WAwLwsFaE/O9Tcw8LvFIS7WPCbXghOAvOJHXsL+tqEvSAVimHhGhMgJ2+zalwuWbIJ3bWQ7GCQDx1BdWBzEZSU=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
Date: Fri, 21 Sep 2007 18:03:55 +0100
User-Agent: KMail/1.9.1
Cc: jeff@garzik.org, mchan@broadcom.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <200709211201.24475.vda.linux@googlemail.com> <20070921.091432.74736040.davem@davemloft.net>
In-Reply-To: <20070921.091432.74736040.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211803.55554.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 September 2007 17:14, David Miller wrote:
> From: Denys Vlasenko <vda.linux@googlemail.com>
> Date: Fri, 21 Sep 2007 12:01:24 +0100
> 
> > Hi Jeff,
> 
> BNX2 and TG3 patches goes through Michael Chan and myself,
> and I usually merge them in instead of Jeff.

Didn't know that, sorry.

Do patches look ok to you?
--
vda
