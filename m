Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbXGGFMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbXGGFMz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 01:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXGGFMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 01:12:48 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34435 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbXGGFMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 01:12:47 -0400
Date: Fri, 6 Jul 2007 22:14:30 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.20.15
Message-ID: <20070707051430.GC20585@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.20.15 kernel.
This has a fix for a security problem with netfilter messages.  Any
2.6.20 user using netfilter is strongly urged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.20.14 and 2.6.20.15

The updated 2.6.20.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.20.y.git;a=summary

thanks,

greg k-h

---------

 Makefile                               |    2 +-
 net/netfilter/nf_conntrack_h323_asn1.c |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)


Summary of changes from v2.6.20.14 to v2.6.20.15
================================================

Greg Kroah-Hartman (1):
      Linux 2.6.20.15

Jing Min Zhao (1):
      nf_conntrack_h323: add checking of out-of-range on choices' index values

