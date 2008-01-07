Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbYAGQgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbYAGQgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbYAGQgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:36:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43978 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbYAGQgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:36:39 -0500
Date: Mon, 7 Jan 2008 08:35:07 -0800
From: Greg KH <greg@kroah.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: stable@kernel.org, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, mingo@elte.hu, torvalds@linux-foundation.org,
       clameter@sgi.com
Subject: Re: [stable] [PATCH] slub: provide /proc/slabinfo
Message-ID: <20080107163507.GA18981@kroah.com>
References: <Pine.LNX.4.64.0801071426350.31604@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801071426350.31604@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 02:28:10PM +0200, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> [ Upstream commits: 57ed3eda977a215f054102b460ab0eb5d8d112e6,
>   6b6adc22a01941165d5af9a3e69e28e948b28f47, and
>   158a962422e4a54dc256b6a9b9562f3d30d34d9c ]
> 
> This adds a read-only /proc/slabinfo file on SLUB, that makes slabtop work.

This feels to me like a "feature addition", and as such, I don't think
it is aplicable for the .23-stable tree.

Unless others strongly object?

thanks,

greg k-h
