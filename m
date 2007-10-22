Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbXJVD6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbXJVD6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 23:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbXJVD6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 23:58:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55757 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbXJVD6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 23:58:30 -0400
Date: Sun, 21 Oct 2007 20:59:54 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Fricaccia <thomas_fricacci@yahoo.com>
Cc: Crispin Cowan <crispin@crispincowan.com>, linux-kernel@vger.kernel.org,
       LSM ML <linux-security-module@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LSM conversion to static interface
Message-ID: <20071022035954.GA30991@kroah.com>
References: <200710220224.l9M2Og5t020815@sapphire.spiritone.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710220224.l9M2Og5t020815@sapphire.spiritone.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 07:24:42PM -0700, Thomas Fricaccia wrote:
> Yes, I think Crispin has succinctly summed it up:  irrevocably closing
> the LSM prevents commercial customers from using security modules other
> than that provided by their Linux distributor.

Any "customer" using a security model other than provided by their Linux
distributor instantly voided all support from that distro by doing that.

So, since the support is gone, they can easily build their own kernels,
with their own LSM interfaces, and get the exact same lack of support :)

And, what are these "other LSM modules" you speak of that people rely on
to run their businesses?

> As Sarbanes-Oxley and
> other regulatory laws require these customers to use "standard
> kernels", the result is a rather dreary form of vendor lock-in, where the
> security framework is coupled to the distribution.

Wait, what?

Since when does Sarbanes-Oxley decree that a company must use a
"standard kernel"?  And just exactly what defines such "standard
kernel"?  Can you point out where in that bill it requires such a thing?

Totally confused,

greg k-h
