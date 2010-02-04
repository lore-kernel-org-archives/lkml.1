Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab0BDXNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:13:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49240
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758479Ab0BDXNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:13:43 -0500
Date: Thu, 04 Feb 2010 15:13:57 -0800 (PST)
Message-Id: <20100204.151357.18104114.davem@davemloft.net>
To: ktpedre@sandia.gov
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] seastar - SeaStar Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1265324464.23523.51.camel@hawkeye.sandia.gov>
References: <1265160242.15726.20.camel@hawkeye.sandia.gov>
	<20100202.174045.135005544.davem@davemloft.net>
	<1265324464.23523.51.camel@hawkeye.sandia.gov>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kevin Pedretti" <ktpedre@sandia.gov>
Date: Thu, 4 Feb 2010 16:01:04 -0700

> Please let me know if these issues are show-stoppers as far as inclusion
> goes.  We would like to get this open-source driver into the kernel so
> us and others with Cray XT systems can start to benefit from it, and
> continue to automatically track kernel API changes. 

I may let it in as-is, thanks for the explanations.

Could you at least consider perhaps that since it isn't
really ethernet, not pretending that it is may be something
to look at?
