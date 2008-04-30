Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbYD3Xfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbYD3Xfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761307AbYD3XfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:35:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41254 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761038AbYD3XfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:35:23 -0400
Date: Wed, 30 Apr 2008 16:34:50 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080430233450.GA1059@kroah.com>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <alpine.LFD.1.10.0804301253290.2980@woody.linux-foundation.org> <alpine.LFD.1.10.0804301307460.2980@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804301307460.2980@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 01:14:39PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 30 Apr 2008, Linus Torvalds wrote:
> > 
> > In fact, I'd personally like to make it even shorter
> 
> Just to clarify: I'd actually like to make the merge window be just a 
> week. If even that.

I'd go for that.  The only one with a possible problem might be Andrew
due to his need to rebase his 1000+ individual patches before he sends
them to you :)

Everyone else should have things queued up and ready to go for you as
it's not like we don't have some warning that the window is about to
open up...

thanks,

greg k-h
