Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbYEKGJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbYEKGJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 02:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbYEKGJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 02:09:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45054
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750795AbYEKGJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 02:09:05 -0400
Date: Sat, 10 May 2008 23:08:56 -0700 (PDT)
Message-Id: <20080510.230856.193689901.davem@davemloft.net>
To: jesper@krogh.cc
Cc: yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
From: David Miller <davem@davemloft.net>
In-Reply-To: <482687B6.5070101@krogh.cc>
References: <48258074.7060306@krogh.cc>
	<20080510.213431.193696750.davem@davemloft.net>
	<482687B6.5070101@krogh.cc>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Krogh <jesper@krogh.cc>
Date: Sun, 11 May 2008 07:44:22 +0200

> David Miller wrote:
> > From: Jesper Krogh <jesper@krogh.cc>
> > Date: Sat, 10 May 2008 13:01:08 +0200
> > 
> >> Any good suggestions about the "Transmit timed out" messages. It
> >> currently leads to a system that "doesnt die" but doesnt respond within
> >> 15 minutes of load of the network adapter.
> > 
> > It's likely some bug in the driver that hangs the card for whatever
> > reason, which we'll need to work out.
> 
> What can I do to help out? I'd really like to get the 10g interface
> operational quite soon.

I personally don't have the time to work on this currently, but maybe
I will later this week.
