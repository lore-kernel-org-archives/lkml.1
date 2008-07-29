Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbYG2Dj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbYG2Dj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 23:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYG2Dju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 23:39:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36406 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbYG2Djt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 23:39:49 -0400
Date: Mon, 28 Jul 2008 20:39:44 -0700
From: Greg KH <greg@kroah.com>
To: Eric Paris <eparis@redhat.com>
Cc: malware-list@lists.printk.net, linux-kernel@vger.kernel.org
Subject: Re: request for comment: generic kernel interface for malware
	vendors
Message-ID: <20080729033944.GD12085@kroah.com>
References: <1216613887.2960.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216613887.2960.18.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 12:18:07AM -0400, Eric Paris wrote:
> 
> This is a request for comment.  This is a first stab and I'm here to
> address all of the concerns that people have.  Please don't hold back,
> I've got thick skin.  BUT, I don't want to hear 'this is how we have
> been doing it, do it that way.'  I want to hear how this won't work for
> your needs (and WHY) or how we can do it better.
> 
> you can find the patches at:
> http://people.redhat.com/~eparis/talpa

You need to actually send the code to the mailing list if you expect
anyone to read it :)

And we need to know what you are trying to achieve here, without that,
there is no way to evaluate if the implementation matches this or not.

thanks,

greg k-h
