Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab0BEBEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 20:04:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49945
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933610Ab0BEBEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 20:04:35 -0500
Date: Thu, 04 Feb 2010 17:04:48 -0800 (PST)
Message-Id: <20100204.170448.149507765.davem@davemloft.net>
To: ktpedre@sandia.gov
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] seastar - SeaStar Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1265330214.23523.78.camel@hawkeye.sandia.gov>
References: <1265324464.23523.51.camel@hawkeye.sandia.gov>
	<20100204.151357.18104114.davem@davemloft.net>
	<1265330214.23523.78.camel@hawkeye.sandia.gov>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kevin Pedretti" <ktpedre@sandia.gov>
Date: Thu, 4 Feb 2010 17:36:54 -0700

> Sure, I'm open to doing this and would appreciate any example drivers
> you could point me at.

I can't think of any sorry.

> We do need to keep the capability though of talking to Cray's
> existing proprietary "ethernet" over seastar driver, which the
> existing driver does.  If we go this route of being a non-Ethernet
> device, do you think it would still be possible to support this?

I don't think it will break communication with Cray's stuff.
