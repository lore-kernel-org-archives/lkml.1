Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbYGaO7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbYGaO7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYGaO71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:59:27 -0400
Received: from hs-out-0708.google.com ([64.233.178.243]:38353 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYGaO70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XNwj3bkfuo1ZmKcNoHUEhHu9Ah3hRLF38LXul3kBo5fzgv4jAHBlc50ppkz9dyS1j4
         CsQibC5lY0PG92nslzDJwJshKRd0ItanRy7+WsIncI1ImF7B4t6s20LfY80A2BlAO4Zz
         0AzrNFYngHIeLGPG4sbf7ofQFc4mxyeFZKpzg=
Message-ID: <2d460de70807310759s2a7d6c4k5ba7e0e6a5bd9cf6@mail.gmail.com>
Date: Thu, 31 Jul 2008 16:59:24 +0200
From: "Richard Hartmann" <richih.mailinglist@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: iptables, NAT, DNS & Dan Kaminsky
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080730195548.GA615@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2d460de70807300753w33c43340xaa52c54add501306@mail.gmail.com>
	 <20080730195548.GA615@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,


On Wed, Jul 30, 2008 at 21:55, Willy Tarreau <w@1wt.eu> wrote:

> you should re-post your question to relevant lists. I think that
> the netfilter ML would be more appropriate. The list you posted to
> is about Linux kernel development, which has nothing to do with
> how to setup iptables rules, so I don't think you'll find useful
> answers here, if any.

I also asked said list, but as I am especially concerned about
what kernels versions act in which way, I thought I would try
my luck here, as well.


> And BTW I don't think that many of the people
> reading LKML care a dime about the "exploit" for poorly configured
> DNS servers.

It is an exploit that is being abused as we speak and, unless you
mean source address filtering or the like, has nothing to do with
how the servers are configured (well, unless they are authorative
nameservers, but..).


Thanks,
Richard
