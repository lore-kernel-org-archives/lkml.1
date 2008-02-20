Return-Path: <linux-kernel-owner+w=401wt.eu-S1764349AbYBTVme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764349AbYBTVme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYBTVmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:42:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46188
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751847AbYBTVmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:42:20 -0500
Date: Wed, 20 Feb 2008 13:42:57 -0800 (PST)
Message-Id: <20080220.134257.41491836.davem@davemloft.net>
To: bfields@fieldses.org
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080220212302.GJ30160@fieldses.org>
References: <20080220165557.GA18816@havoc.gtf.org>
	<20080220.131530.18314167.davem@davemloft.net>
	<20080220212302.GJ30160@fieldses.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@fieldses.org>
Date: Wed, 20 Feb 2008 16:23:02 -0500

> On Wed, Feb 20, 2008 at 01:15:30PM -0800, David Miller wrote:
> > From: Jeff Garzik <jeff@garzik.org>
> > Date: Wed, 20 Feb 2008 11:55:57 -0500
> > 
> > > 
> > > Note:  this is based off of Linus's latest commit
> > > (5d9c4a7de64d398604a978d267a6987f1f4025b7), since all my previous
> > > submissions are now upstream (thanks!).
> > 
> > The whole point of my not rebasing net-2.6 is so that you can always
> > use it as a base.
> > 
> > With what you've giving me now I either have to:
> > 
> > 1) Pull in Linus's tree to net-2.6, then pull from you.
> > 
> > 2) Pull in directly from you to get it all.
> 
> Why are either of those a problem?

Because it forces me to pull Linus's upstream into net-2.6,
I don't have any choice in the matter.
