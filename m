Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbZE2ELd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbZE2ELd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 00:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZE2ELY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 00:11:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37844
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161AbZE2ELX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 00:11:23 -0400
Date: Thu, 28 May 2009 21:11:23 -0700 (PDT)
Message-Id: <20090528.211123.46272556.davem@davemloft.net>
To: wmb@firmworks.com
Cc: benh@kernel.crashing.org, grant.likely@secretlab.ca, dbaryshkov@gmail.com,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A1F4189.8060702@firmworks.com>
References: <1243549318.17903.9.camel@pasglop>
	<20090529013908.GA7831@yookeroo.seuss>
	<4A1F4189.8060702@firmworks.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mitch Bradley <wmb@firmworks.com>
Date: Fri, 29 May 2009 09:59:37 +0800

> I have an embeddable FCode interpreter that could be built into a
> kernel.  Perhaps it's time to resurrect that.  The total size is on
> the order of 50K with debugging tools included; probably more like 35K
> if stripped down to just the essentials.

If you have a GPL'd OF tokenizer in there I'll give you a big
wet kiss. :-)
