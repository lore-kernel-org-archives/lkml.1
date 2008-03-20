Return-Path: <linux-kernel-owner+w=401wt.eu-S1759196AbYCTB3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196AbYCTB3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 21:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYCTB24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 21:28:56 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1547 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYCTB2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 21:28:55 -0400
Subject: Re: [PATCH] [RFC] [IPv6] spelling fix in /proc:
	/proc/sys/net/ipv6/conf/default/temp_prefered_lft
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: benoit.boissinot@ens-lyon.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, pekkas@netcore.fi, yoshfuji@linux-ipv6.org
In-Reply-To: <20080319.135205.125229102.davem@davemloft.net>
References: <20080319204227.GF6935@ens-lyon.fr>
	 <20080319.135205.125229102.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 19 Mar 2008 18:25:19 -0700
Message-Id: <1205976319.26345.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-19 at 13:52 -0700, David Miller wrote:
> From: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
> Date: Wed, 19 Mar 2008 21:42:27 +0100
> > Here is a patch to fix all the spelling error (prefered -> preferred)
> I think this doesn't add any value.
> If the procfs file name has to remain the same, which it does,
> changing variable and macro names to be different will only
> cause merge conflicts and pain yet have no redeeming value.

I disagree.  Proper spelling has value.
Misspelled words require additional time to read and parse.

Any change can cause merge conflicts.

A simple comment on the proc name use should be added though.


