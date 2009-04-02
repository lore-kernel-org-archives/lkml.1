Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbZDBJjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbZDBJjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbZDBJjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:39:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58372 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbZDBJjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:39:01 -0400
Message-ID: <49D487A6.407@redhat.com>
Date: Thu, 02 Apr 2009 12:38:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: ghaskins@novell.com, anthony@codemonkey.ws, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com> <20090402091639.GA30126@gondor.apana.org.au> <49D484F5.2000400@redhat.com> <20090402092936.GA30333@gondor.apana.org.au>
In-Reply-To: <20090402092936.GA30333@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Thu, Apr 02, 2009 at 12:27:17PM +0300, Avi Kivity wrote:
>   
>> If tap told us when the packets were actually transmitted, life would be  
>> wonderful:
>>     
>
> And why do we need this? Because we are in user space!
>
>   

Why does a kernel solution not need to know when a packet is transmitted?

-- 
error compiling committee.c: too many arguments to function

