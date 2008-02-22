Return-Path: <linux-kernel-owner+w=401wt.eu-S934758AbYBVUOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934758AbYBVUOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbYBVUO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:14:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36450 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764199AbYBVUOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:14:24 -0500
Date: Fri, 22 Feb 2008 12:14:13 -0800
From: Greg KH <greg@kroah.com>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: [stable] [2.6.22.y] {13/14} - NFSv2/v3: Fix a memory leak when
	using -onolock - on top of 2.6.22.17
Message-ID: <20080222201413.GA12330@kroah.com>
References: <6101e8c40802071203o1b32c2c2md53859623228463@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40802071203o1b32c2c2md53859623228463@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 09:03:52PM +0100, Oliver Pinter wrote:
> aka: nfs-unmount-leak.patch
> 
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date: Tue Dec 11 11:05:19 2007 -0500
> Subject: NFSv2/v3: Fix a memory leak when using -onolock
> Patch-mainline: 2.6.24
> References: 336253
> 
> mainline: 13ef7b69b54aa8ae4ed264d0bf41339737f8543a

No, that's the wrong commit id.  Please be more careful next time, it's
no fun having to verify every id to make sure that I can trust these
patches...

It's 5cef338b30c110daf547fb13d99f0c77f2a79fbc just for future reference.

thanks,

greg k-h
