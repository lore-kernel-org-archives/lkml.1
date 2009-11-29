Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbZK2IVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbZK2IVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 03:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZK2IVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 03:21:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38014
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830AbZK2IVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 03:21:37 -0500
Date: Sun, 29 Nov 2009 00:21:42 -0800 (PST)
Message-Id: <20091129.002142.230416671.davem@davemloft.net>
To: nico@fluxnic.net
Cc: khilman@deeprootsystems.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NET: smc91x: convert to dev_pm_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0911242012500.2059@xanadu.home>
References: <1259103467-31016-1-git-send-email-khilman@deeprootsystems.com>
	<alpine.LFD.2.00.0911242012500.2059@xanadu.home>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Pitre <nico@fluxnic.net>
Date: Tue, 24 Nov 2009 20:13:15 -0500 (EST)

> On Tue, 24 Nov 2009, Kevin Hilman wrote:
> 
>> Convert smc91x driver from legacy PM hooks over to using dev_pm_ops.
>> 
>> Tested on OMAP3 platform.
>> 
>> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
> 
> Acked-by: Nicolas Pitre <nico@fluxnic.net>

Applied to net-next-2.6, thanks.
