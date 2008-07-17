Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbYGQWJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbYGQWJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYGQWJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:09:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47187
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754475AbYGQWJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:09:01 -0400
Date: Thu, 17 Jul 2008 15:09:01 -0700 (PDT)
Message-Id: <20080717.150901.02086760.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, rjw@sisk.pl
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison
 overwritten
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080717220600.GA1701@elte.hu>
References: <20080717214222.GA29449@elte.hu>
	<20080717.144504.96425101.davem@davemloft.net>
	<20080717220600.GA1701@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 18 Jul 2008 00:06:00 +0200

> > > Perhaps SLUB debugging got smarter?
> 
> and Cc:-ed SLUB folks. Could be a sleeper cell of bugs gone active ;-) 

This bug would be a quite positive result then :)
