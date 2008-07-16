Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbYGPDVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbYGPDVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 23:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbYGPDVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 23:21:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56691 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbYGPDVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 23:21:05 -0400
Date: Tue, 15 Jul 2008 20:13:19 -0700
From: Greg KH <greg@kroah.com>
To: Tiago Assumpcao <tiago@assumpcao.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, pageexec@freemail.hu,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
Message-ID: <20080716031319.GA7558@kroah.com>
References: <alpine.LFD.1.10.0807151425170.2867@woody.linux-foundation.org> <487D3C17.31467.1C3C0441@pageexec.freemail.hu> <alpine.LFD.1.10.0807151707450.2867@woody.linux-foundation.org> <487D4301.5080609@assumpcao.org> <alpine.LFD.1.10.0807151749570.2867@woody.linux-foundation.org> <487D4A7B.8090403@assumpcao.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487D4A7B.8090403@assumpcao.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 10:10:19PM -0300, Tiago Assumpcao wrote:
>
> All I ask for is to receive the "There are updates available." message as 
> soon as one security problem is reported, understood and treated by your 
> development part. And that is, the sooner possible, if you please.

Do we not already do this today?  I know I do this as soon as possible
for any reported problem for the -stable tree, as soon as the fix is in
Linus's tree.

See the 2.6.25.11 release for an example of this.

> Plus, if one bothers, to be able to know the exact location of this bug and 
> its characteristics.

That's the extra work that you are saying we also need to do.  Linus and
others have already detailed why we don't do that.

thanks,

greg k-h
