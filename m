Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYFBPqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYFBPqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYFBPqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:46:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57725 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbYFBPqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:46:44 -0400
Date: Mon, 2 Jun 2008 08:44:36 -0700
From: Greg KH <greg@kroah.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: gregkh@suse.de, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.4
Message-ID: <20080602154436.GA5148@kroah.com>
References: <20080515150721.GA8420@kroah.com> <20080602.132856.11964619.nemoto@toshiba-tops.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602.132856.11964619.nemoto@toshiba-tops.co.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 01:28:56PM +0900, Atsushi Nemoto wrote:
> On Thu, 15 May 2008 08:07:21 -0700, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> > We (the -stable team) are announcing the release of the 2.6.25.4 kernel.
> > 
> > It contains a bunch of bug fixes, and one security update, so all users
> > of the 2.6.25 series are encouraged to upgrade.
> 
> Could you tell me which commit contains the "security update" ?
> I could not find it by reading commitlog.
> 
> Is it
> "{nfnetlink, ip, ip6}_queue: fix skb_over_panic when enlarging packets"
> or
> "nf_conntrack: padding breaks conntrack hash on ARM"
> or
> "sparc: Fix SA_ONSTACK signal handling."

This last one is the one that I was referring to.

thanks,

greg k-h
