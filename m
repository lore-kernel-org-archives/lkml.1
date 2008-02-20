Return-Path: <linux-kernel-owner+w=401wt.eu-S1764214AbYBTVXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764214AbYBTVXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbYBTVXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:23:07 -0500
Received: from mail.fieldses.org ([66.93.2.214]:44589 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232AbYBTVXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:23:06 -0500
Date: Wed, 20 Feb 2008 16:23:02 -0500
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes
Message-ID: <20080220212302.GJ30160@fieldses.org>
References: <20080220165557.GA18816@havoc.gtf.org> <20080220.131530.18314167.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220.131530.18314167.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 01:15:30PM -0800, David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Wed, 20 Feb 2008 11:55:57 -0500
> 
> > 
> > Note:  this is based off of Linus's latest commit
> > (5d9c4a7de64d398604a978d267a6987f1f4025b7), since all my previous
> > submissions are now upstream (thanks!).
> 
> The whole point of my not rebasing net-2.6 is so that you can always
> use it as a base.
> 
> With what you've giving me now I either have to:
> 
> 1) Pull in Linus's tree to net-2.6, then pull from you.
> 
> 2) Pull in directly from you to get it all.

Why are either of those a problem?

--b.
