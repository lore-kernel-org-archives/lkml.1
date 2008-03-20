Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYCTB4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYCTB4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 21:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYCTB4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 21:56:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54315
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752578AbYCTB4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 21:56:34 -0400
Date: Wed, 19 Mar 2008 18:56:49 -0700 (PDT)
Message-Id: <20080319.185649.235399151.davem@davemloft.net>
To: joe@perches.com
Cc: benoit.boissinot@ens-lyon.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, pekkas@netcore.fi, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] [RFC] [IPv6] spelling fix in /proc:
 /proc/sys/net/ipv6/conf/default/temp_prefered_lft
From: David Miller <davem@davemloft.net>
In-Reply-To: <1205976319.26345.20.camel@localhost>
References: <20080319204227.GF6935@ens-lyon.fr>
	<20080319.135205.125229102.davem@davemloft.net>
	<1205976319.26345.20.camel@localhost>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 19 Mar 2008 18:25:19 -0700

> On Wed, 2008-03-19 at 13:52 -0700, David Miller wrote:
> > From: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
> > Date: Wed, 19 Mar 2008 21:42:27 +0100
> > > Here is a patch to fix all the spelling error (prefered -> preferred)
> > I think this doesn't add any value.
> > If the procfs file name has to remain the same, which it does,
> > changing variable and macro names to be different will only
> > cause merge conflicts and pain yet have no redeeming value.
> 
> I disagree.  Proper spelling has value.

Only if it matches the spelling of thing it is implementing!

Making the object being implemented and the variables used to do so
disagree in name will only create other kinds of confusion.
