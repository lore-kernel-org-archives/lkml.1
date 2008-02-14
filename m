Return-Path: <linux-kernel-owner+w=401wt.eu-S1765076AbYBNFzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765076AbYBNFzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYBNFzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:55:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47413
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbYBNFzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:55:35 -0500
Date: Wed, 13 Feb 2008 21:56:06 -0800 (PST)
Message-Id: <20080213.215606.216922244.davem@davemloft.net>
To: jmorris@namei.org
Cc: paul.moore@hp.com, bunk@kernel.org, coreteam@netfilter.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make secmark_tg_destroy() static
From: David Miller <davem@davemloft.net>
In-Reply-To: <Xine.LNX.4.64.0802141040440.3559@us.intercode.com.au>
References: <20080213212940.GH3383@cs181133002.pp.htv.fi>
	<200802131634.51116.paul.moore@hp.com>
	<Xine.LNX.4.64.0802141040440.3559@us.intercode.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Morris <jmorris@namei.org>
Date: Thu, 14 Feb 2008 10:41:19 +1100 (EST)

> On Wed, 13 Feb 2008, Paul Moore wrote:
> 
> > On Wednesday 13 February 2008 4:29:40 pm Adrian Bunk wrote:
> > > This patch makes the needlessly global secmark_tg_destroy() static.
> > >
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > Thanks for catching this.
> > 
> > Acked-by: Paul Moore <paul.moore@hp.com>
> > 
> 
> Applied -- will push to Linus unless the netfilter folk do it first.

I sucked it in, don't worry about it.
