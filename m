Return-Path: <linux-kernel-owner+w=401wt.eu-S1765480AbYBMBWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765480AbYBMBWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbYBMBWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:22:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36879
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754265AbYBMBW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:22:29 -0500
Date: Tue, 12 Feb 2008 17:23:01 -0800 (PST)
Message-Id: <20080212.172301.241607222.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: greg@kroah.com, torvalds@linux-foundation.org, jeff@garzik.org,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080212164726.8eecab43.akpm@linux-foundation.org>
References: <20080212191552.GA20883@kroah.com>
	<20080212.164149.209357519.davem@davemloft.net>
	<20080212164726.8eecab43.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 12 Feb 2008 16:47:26 -0800

> My usual way of fixing these things when they pop up is to just move
> the offending addition to some random position other than
> end-of-list.  I must have done this hundreds of times and as yet I
> don't think anyone has noticed ;)

That sounds like a real useful usage of your time.

I think my proposal saves everyone, including you, this time and the
effort necessary to implement it would only need to be expended once
instead of this ever present time and learning sink you seem to be
advocating.
