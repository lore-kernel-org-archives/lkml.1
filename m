Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbZG1Sds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbZG1Sds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZG1Sdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:33:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36691
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755473AbZG1Sdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:33:46 -0400
Date: Tue, 28 Jul 2009 11:33:53 -0700 (PDT)
Message-Id: <20090728.113353.08715297.davem@davemloft.net>
To: joe@perches.com
Cc: linville@tuxdriver.com, julia@diku.dk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add networking wireless drivers section
From: David Miller <davem@davemloft.net>
In-Reply-To: <1248804397.18284.5.camel@Joe-Laptop.home>
References: <Pine.LNX.4.64.0907281753540.28189@ask.diku.dk>
	<20090728.103044.179053537.davem@davemloft.net>
	<1248804397.18284.5.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 28 Jul 2009 11:06:37 -0700

> On Tue, 2009-07-28 at 10:30 -0700, David Miller wrote:
>> Wireless patches need to be CC:'d to linux-wireless so that
>> John Linville can notice and pick them up
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Why not just create a plain "WIRELESS" umbrella entry
that contains all of drivers/net/wireless, net/mac80211,
and net/wireless?
