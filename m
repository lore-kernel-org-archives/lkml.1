Return-Path: <linux-kernel-owner+w=401wt.eu-S1423406AbXDYXyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423406AbXDYXyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423407AbXDYXyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:54:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:47409 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423406AbXDYXym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:54:42 -0400
Date: Wed, 25 Apr 2007 16:52:10 -0700
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.20.8
Message-ID: <20070425235210.GA26888@suse.de>
References: <20070425212225.GA21200@kroah.com> <20070425.162944.26532464.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425.162944.26532464.davem@davemloft.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 04:29:44PM -0700, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Wed, 25 Apr 2007 14:22:25 -0700
> 
> > We (the -stable team) are announcing the release of the 2.6.20.8 kernel.
> > This release has a security bugfix so any users of kernels older than
> > 2.6.20.7 are highly encouraged to upgrade as soon as possible.
> 
> Greg, Yoshifuji sent you an ipv6 security fix of nearly
> equally severity yesterday.
> 
> Why did you leave that out?

Because I haven't been applying any network-related patches unless you
forward them to me, based on what happened the last time I did that
without asking :)

So, sorry, I didn't realize this was a big issue, can you forward the
needed patches to me?  I'll do a new release with them in it after I get
back from dinner.

thanks,

greg k-h

