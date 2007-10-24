Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbXJXDhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbXJXDhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 23:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbXJXDh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 23:37:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58524 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbXJXDh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 23:37:26 -0400
Date: Tue, 23 Oct 2007 20:41:36 -0700
From: Greg KH <greg@kroah.com>
To: Crispin Cowan <crispin@crispincowan.com>
Cc: Giacomo Catenazzi <cate@debian.org>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LSM ML <linux-security-module@vger.kernel.org>
Subject: Re: LSM conversion to static interface
Message-ID: <20071024034136.GC14383@kroah.com>
References: <200710221700.l9MH0klg006152@sapphire.spiritone.com> <471D8C54.4050907@debian.org> <471D9ECB.6060400@crispincowan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471D9ECB.6060400@crispincowan.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 12:12:11AM -0700, Crispin Cowan wrote:
>     * Some people are not comfortable building kernels from source. It
>       doesn't matter how easy *you* think it is, it is a significant
>       barrier to entry for a lot of people. Especially if their day job
>       is systems or security administration, and not kernel hacking.

That's why I wrote a whole book about how to do just that.  And it's
free, print it out and give it to all your friends!
	www.kroah.com/lkn/

thanks,

greg k-h
