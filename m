Return-Path: <linux-kernel-owner+w=401wt.eu-S1752228AbZE2E4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbZE2E4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 00:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZE2E4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 00:56:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:57283 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbZE2E4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 00:56:25 -0400
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: wmb@firmworks.com, grant.likely@secretlab.ca, dbaryshkov@gmail.com,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20090528.211123.46272556.davem@davemloft.net>
References: <1243549318.17903.9.camel@pasglop>
	 <20090529013908.GA7831@yookeroo.seuss> <4A1F4189.8060702@firmworks.com>
	 <20090528.211123.46272556.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 29 May 2009 14:56:01 +1000
Message-Id: <1243572961.17903.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 21:11 -0700, David Miller wrote:
> From: Mitch Bradley <wmb@firmworks.com>
> Date: Fri, 29 May 2009 09:59:37 +0800
> 
> > I have an embeddable FCode interpreter that could be built into a
> > kernel.  Perhaps it's time to resurrect that.  The total size is on
> > the order of 50K with debugging tools included; probably more like 35K
> > if stripped down to just the essentials.
> 
> If you have a GPL'd OF tokenizer in there I'll give you a big
> wet kiss. :-)

openbios doesn't have one ?

Cheers
Ben.


