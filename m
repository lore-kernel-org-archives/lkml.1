Return-Path: <linux-kernel-owner+w=401wt.eu-S966132AbZLHUwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966132AbZLHUwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966106AbZLHUwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:52:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53417
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966104AbZLHUwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:52:05 -0500
Date: Tue, 08 Dec 2009 12:52:11 -0800 (PST)
Message-Id: <20091208.125211.110155993.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0912081249060.3560@localhost.localdomain>
References: <20091205.193505.193701079.davem@davemloft.net>
	<20091208194530.GA24530@elte.hu>
	<alpine.LFD.2.00.0912081249060.3560@localhost.localdomain>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 Dec 2009 12:51:00 -0800 (PST)

> That's my mismerge. I should have removed the strategy field too, not just 
> the ctr_name. My bad, will fix up,

Thanks everyone for working to fix this up.
