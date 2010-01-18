Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873Ab0ARDCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0ARDCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 22:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722Ab0ARDCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 22:02:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36083
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212Ab0ARDCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 22:02:48 -0500
Date: Sun, 17 Jan 2010 19:02:58 -0800 (PST)
Message-Id: <20100117.190258.118476095.davem@davemloft.net>
To: mingo@elte.hu
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sched_clock.c change to -stable?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100116113647.GB31414@elte.hu>
References: <20100116.005541.18991049.davem@davemloft.net>
	<20100116113647.GB31414@elte.hu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 16 Jan 2010 12:36:47 +0100

>> Therefore, do you mind if I send this commit to -stable?
>> 
>> Thanks.
> 
> Sure!
> 
> I've attached the commit for the -stable team's convenience.

Great, I'll submit it also as part of my sparc -stable submission
to make sure they really get it :-)

Thanks!
