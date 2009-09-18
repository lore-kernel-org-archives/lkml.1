Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZIRPJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZIRPJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbZIRPJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:09:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:38468 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbZIRPJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:09:07 -0400
Date: Fri, 18 Sep 2009 08:05:06 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
	maintenance disaster
Message-ID: <20090918150506.GA9307@kroah.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <20090917125759.GA4045@kroah.com> <20090917140548.4e6ee596@lxorguk.ukuu.org.uk> <20090917132909.GB4779@kroah.com> <20090917164325.38994b47@lxorguk.ukuu.org.uk> <20090918060320.GD7104@kroah.com> <20090918102540.0a683607@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090918102540.0a683607@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 10:25:40AM +0100, Alan Cox wrote:
> > > Christoph has already nacked the code and indicated some problems (albeit
> > > in his inimitably friendly fashion) so you had at least one review, you
> > > just apparently didn't like the answer.
> > 
> > No, he did not point out any technical problem with the code that I can
> > find.  I asked for details, but he's probably on a plane at the moment.
> 
> I quote:
> 
> "this touches init code to mount stuff inside the namespace fro ma
> filesystem driver which is a big no-go"

{sigh}

And I responded with a specific question about this, asking what he ment
by it, and referred to a line in the patch, as he had not pointed out
specifically what he was referring to, and asking for a clarification.

This was also the first time I had heard that complaint from what I
recall, so it was new to me.

thanks,

greg k-h
