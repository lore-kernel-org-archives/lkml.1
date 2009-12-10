Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbZLJLVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbZLJLVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 06:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760679AbZLJLU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 06:20:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760622AbZLJLU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 06:20:57 -0500
Date: Thu, 10 Dec 2009 12:21:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: linux-next: manual merge of the tty tree with the trivial tree
In-Reply-To: <20091209202854.GA8222@kroah.com>
Message-ID: <alpine.LNX.2.00.0912101220310.3755@pobox.suse.cz>
References: <20091209162826.a28c6c68.sfr@canb.auug.org.au> <alpine.LNX.2.00.0912091536230.3755@pobox.suse.cz> <20091210021100.b606b224.sfr@canb.auug.org.au> <20091209202854.GA8222@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Greg KH wrote:

> > > > I just used the tty tree version where they clashed.  Jiri, you might
> > > > consider sending that patch to Greg for the tty tree.
> > > 
> > > the trivial tree pull request has already been sent to Linus a day ago. I 
> > > am now waiting whether it will be merged or missed.
> > > 
> > > In the latter case, I will split the tty hunk out and send to Greg. In the 
> > > former case the conflict would have to be solved either by Greg or Linus.
> > 
> > OK, that's fine, thanks.
> 
> Sounds good to me as well.

Linus has merged my tree, so either you or Linus will have to fix the 
conflict.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
