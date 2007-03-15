Return-Path: <linux-kernel-owner+w=401wt.eu-S964960AbXCOBJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960AbXCOBJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 21:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964968AbXCOBJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 21:09:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45666
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S964960AbXCOBJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 21:09:19 -0400
Date: Wed, 14 Mar 2007 18:09:15 -0700 (PDT)
Message-Id: <20070314.180915.74747355.davem@davemloft.net>
To: wli@holomorphy.com
Cc: viro@ftp.linux.org.uk, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/17] sparc: nr_free_pages() is unsigned long
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070314150612.GU2986@holomorphy.com>
References: <E1HRPdC-0003S1-0h@ZenIV.linux.org.uk>
	<20070314150612.GU2986@holomorphy.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Lee Irwin III <wli@holomorphy.com>
Date: Wed, 14 Mar 2007 08:06:12 -0700

> On Wed, Mar 14, 2007 at 09:18:50AM +0000, Al Viro wrote:
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > ---
> >  arch/sparc/mm/init.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Dave, I trust you'll pick it up until I get a git tree going.
> 
> Acked-by: William Irwin <wli@holomorphy.com>

What usually happens when Al sends a set like this is that
Linus picks it up directly, and I've just verified that this
is in fact what has happened this time too :-)
