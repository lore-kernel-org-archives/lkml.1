Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZFYFho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZFYFho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZFYFhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:37:31 -0400
Received: from mail.lang.hm ([64.81.33.126]:59593 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759087AbZFYFhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:37:22 -0400
Date: Wed, 24 Jun 2009 22:37:14 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: alex@digriz.org.uk, linux-kernel@vger.kernel.org
Subject: Re: When does Linux drop UDP packets?
In-Reply-To: <20090625050052.GA30594@gondor.apana.org.au>
Message-ID: <alpine.DEB.1.10.0906242236400.28437@asgard.lang.hm>
References: <20090625050052.GA30594@gondor.apana.org.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009, Herbert Xu wrote:

> david@lang.hm wrote:
>>
>> given that each subnet will be a minimum of 4 IP addresses (the network
>> address, two useable, and thr broadcast address), putting each machine on
>> it's own subnet and routing between them on the switch would be very
>> wasteful of addresses.
>
> What I mean is that if you have snooping switches then multicasts
> and broadcasts are not the same even when you're on the same subnet.

please explain more? how do they differ?

David Lang
