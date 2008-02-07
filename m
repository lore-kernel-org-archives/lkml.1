Return-Path: <linux-kernel-owner+w=401wt.eu-S1760544AbYBGCgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbYBGCgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 21:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758630AbYBGCg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 21:36:26 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:25656 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758553AbYBGCgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 21:36:24 -0500
Date: Thu, 7 Feb 2008 11:35:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] - SH/Dreamcast - fix maple bus bugs
Message-ID: <20080207023523.GE13945@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-sh <linux-sh@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <1202337981.6162.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202337981.6162.8.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 10:46:21PM +0000, Adrian McMenamin wrote:
> This patch is fundamentally about fixing up the whitespace problems introduced by my previous patch (that brought the code into mainline). A second patch will follow that will fix memory leaks. The two need to be applied sequentially.
> 
Please do not linewrap, this ends up going directly in to the commit.

> Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> 
Signed-off-by, please.

Also, please use a more helpful subject. Something like:
'maple: <short description of meaningful change>'. I've had to make
something up arbitrarily for this entire series based off of your
comments.

After some munging, git-am finally took it, so the series is now applied.
