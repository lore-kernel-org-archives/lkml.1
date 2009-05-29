Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbZE2FMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbZE2FMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 01:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZE2FLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 01:11:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60758
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236AbZE2FLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 01:11:52 -0400
Date: Thu, 28 May 2009 22:11:51 -0700 (PDT)
Message-Id: <20090528.221151.162168405.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: wmb@firmworks.com, grant.likely@secretlab.ca, dbaryshkov@gmail.com,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <1243572961.17903.28.camel@pasglop>
References: <4A1F4189.8060702@firmworks.com>
	<20090528.211123.46272556.davem@davemloft.net>
	<1243572961.17903.28.camel@pasglop>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Fri, 29 May 2009 14:56:01 +1000

> On Thu, 2009-05-28 at 21:11 -0700, David Miller wrote:
>> From: Mitch Bradley <wmb@firmworks.com>
>> Date: Fri, 29 May 2009 09:59:37 +0800
>> 
>> > I have an embeddable FCode interpreter that could be built into a
>> > kernel.  Perhaps it's time to resurrect that.  The total size is on
>> > the order of 50K with debugging tools included; probably more like 35K
>> > if stripped down to just the essentials.
>> 
>> If you have a GPL'd OF tokenizer in there I'll give you a big
>> wet kiss. :-)
> 
> openbios doesn't have one ?

It's MIT/BSD licensed.


