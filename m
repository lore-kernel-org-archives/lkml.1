Return-Path: <linux-kernel-owner+w=401wt.eu-S1751178AbXBMWBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbXBMWBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbXBMWBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:01:06 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54879 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbXBMWBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:01:04 -0500
Date: Tue, 13 Feb 2007 14:00:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
Subject: Re: Please pull x86 updates
Message-Id: <20070213140051.70de4b2c.akpm@linux-foundation.org>
In-Reply-To: <200702131340.57004.andi@firstfloor.org>
References: <200702131340.57004.andi@firstfloor.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Feb 2007 13:40:56 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> Linux please pull from
> 
>   git://one.firstfloor.org/home/andi/git/linux-2.6
> 
> This is not all, but I pruned lots of stuff that still wasn't
> quite ready. Less is more I guess.

I guess this means that hrtimers&dynticks remains on hold.  Do you have a feel
for when batch #2 will be pushed?
