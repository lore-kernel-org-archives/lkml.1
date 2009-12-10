Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZLJOjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZLJOjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZLJOjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:39:11 -0500
Received: from kroah.org ([198.145.64.141]:46891 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbZLJOjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:39:10 -0500
Date: Thu, 10 Dec 2009 06:39:17 -0800
From: Greg KH <greg@kroah.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: linux-next: manual merge of the tty tree with the trivial tree
Message-ID: <20091210143917.GA27161@kroah.com>
References: <20091209162826.a28c6c68.sfr@canb.auug.org.au> <alpine.LNX.2.00.0912091536230.3755@pobox.suse.cz> <20091210021100.b606b224.sfr@canb.auug.org.au> <20091209202854.GA8222@kroah.com> <alpine.LNX.2.00.0912101220310.3755@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0912101220310.3755@pobox.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 12:21:00PM +0100, Jiri Kosina wrote:
> On Wed, 9 Dec 2009, Greg KH wrote:
> 
> > > > > I just used the tty tree version where they clashed.  Jiri, you might
> > > > > consider sending that patch to Greg for the tty tree.
> > > > 
> > > > the trivial tree pull request has already been sent to Linus a day ago. I 
> > > > am now waiting whether it will be merged or missed.
> > > > 
> > > > In the latter case, I will split the tty hunk out and send to Greg. In the 
> > > > former case the conflict would have to be solved either by Greg or Linus.
> > > 
> > > OK, that's fine, thanks.
> > 
> > Sounds good to me as well.
> 
> Linus has merged my tree, so either you or Linus will have to fix the 
> conflict.

Thanks, I'll fix it up in my tree.

greg k-h
