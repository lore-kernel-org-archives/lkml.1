Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbZDUDbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbZDUDbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 23:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZDUDbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 23:31:09 -0400
Received: from kroah.org ([198.145.64.141]:60705 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750951AbZDUDbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 23:31:08 -0400
Date: Mon, 20 Apr 2009 20:27:28 -0700
From: Greg KH <greg@kroah.com>
To: Abhijit Karmarkar <awk@google.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] question regarding the -stable patch queue ?
Message-ID: <20090421032728.GA14175@kroah.com>
References: <88cc3e770904201826odfde9baodcf8c221a0296909@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88cc3e770904201826odfde9baodcf8c221a0296909@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 06:26:53PM -0700, Abhijit Karmarkar wrote:
> hi,
> 
> i am trying to find if a particular upstream commit [1] will appear in
> the next -stable release of 2.6.28 kernel.

Yes it will.

> i see this commit being marked as "-stable candidate". does that mean
> it will automatically make it to the next stable release?

Yes.

> or should i submit a patch against the latest 2.6.28 stable series, to
> have this patch queued up for next stable release (2.6.28.10). can
> someone please advice?

If you know that the commit that went into Linus's tree will not apply
to the 2.6.28-stable tree, please send an updated version to the
stable@kernel.org address.

> what is the recommend way to do this search ("will upstream patch X be
> included in the next stable release")? so i don't bug this list in
> future with similar queries.

Just ask stable@kernel.org about it.  We've been a bit behind on
flushing out the -stable queue (right now my todo-stable mbox contains
399 emails I need to wade through), due to vacations and conferences.
I'm slowly getting there, sorry for the delay.

thanks for your patience,

greg k-h
