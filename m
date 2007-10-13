Return-Path: <linux-kernel-owner+w=401wt.eu-S1762723AbXJMUrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762723AbXJMUrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 16:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbXJMUrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 16:47:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37182 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbXJMUrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 16:47:35 -0400
Date: Sat, 13 Oct 2007 21:47:31 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] missing includes in arch/powerpc/platforms/52xx/lite5200.c
Message-ID: <20071013204731.GN8181@ftp.linux.org.uk>
References: <20071013184008.GL8181@ftp.linux.org.uk> <fa686aa40710131335y710cf6edy59a46d365b1d6d67@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa40710131335y710cf6edy59a46d365b1d6d67@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 02:35:26PM -0600, Grant Likely wrote:
> On 10/13/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Nak, this patch should be used to fix it instead.  A change to
> lite5200 got dropped during merging.
> 
> http://patchwork.ozlabs.org/linuxppc/patch?id=14077

Fine by me.
