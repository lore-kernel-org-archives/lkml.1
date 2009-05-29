Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZE2CAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZE2CAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 22:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbZE2CAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 22:00:17 -0400
Received: from rs35.luxsci.com ([66.216.127.90]:43930 "EHLO rs35.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbZE2CAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 22:00:15 -0400
Message-ID: <4A1F4189.8060702@firmworks.com>
Date: Fri, 29 May 2009 09:59:37 +0800
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
References: <20090527175609.GB31861@flint.arm.linux.org.uk>	<1243496236.3171.140.camel@pasglop>	<20090528091513.GA14789@n2100.arm.linux.org.uk>	<20090528.025739.16559619.davem@davemloft.net>	<gvlvcs$ub5$1@ger.gmane.org>	<fa686aa40905280713u2b3ef5fvbe3d58ccdb629b60@mail.gmail.com>	<1243549318.17903.9.camel@pasglop> <20090529013908.GA7831@yookeroo.seuss>
In-Reply-To: <20090529013908.GA7831@yookeroo.seuss>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an embeddable FCode interpreter that could be built into a 
kernel.  Perhaps it's time to resurrect that.  The total size is on the 
order of 50K with debugging tools included; probably more like 35K if 
stripped down to just the essentials.

