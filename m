Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZCNSpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZCNSpt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 14:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbZCNSph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 14:45:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37877
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754441AbZCNSpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 14:45:36 -0400
Date: Sat, 14 Mar 2009 11:45:22 -0700 (PDT)
Message-Id: <20090314.114522.19720687.davem@davemloft.net>
To: therbert@google.com
Cc: yanmin_zhang@linux.intel.com, bhutchings@solarflare.com,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
       jesse.brandeburg@intel.com, shemminger@vyatta.com
Subject: Re: [RFC v2: Patch 1/3] net: hand off skb list to other cpu to
 submit to upper layer
From: David Miller <davem@davemloft.net>
In-Reply-To: <65634d660903141115w7e164134ycece307f041e93a9@mail.gmail.com>
References: <65634d660903131724s49009177pdc11005aa76a4b56@mail.gmail.com>
	<20090313.191951.228619450.davem@davemloft.net>
	<65634d660903141115w7e164134ycece307f041e93a9@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Herbert <therbert@google.com>
Date: Sat, 14 Mar 2009 11:15:21 -0700

> I suppose it may be counter-intuitive, but I am not making a general
> claim.  I would only suggest that these software hacks could be a very
> good approximation or substitute for hardware functionality.  This is
> a generic way to get more performance out of deficient or lower end
> NICs.

They certainly could.  Why don't you post the current version
of your patches so we have something concrete to discuss?
