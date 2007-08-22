Return-Path: <linux-kernel-owner+w=401wt.eu-S934503AbXHVXRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934503AbXHVXRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932600AbXHVXR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:17:29 -0400
Received: from mx1.suse.de ([195.135.220.2]:57135 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419AbXHVXR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:17:28 -0400
Date: Wed, 22 Aug 2007 16:05:26 -0700
From: Greg KH <gregkh@suse.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Prakash Punnoor <prakash@punnoor.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: [2.6.20.17 review 35/58] forcedeth bug fix: realtek phy
Message-ID: <20070822230526.GC32121@suse.de>
References: <20070822083844.%N@1wt.eu> <20070822084026.%N@1wt.eu> <200708222015.04141.prakash@punnoor.de> <20070822204225.GD14132@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822204225.GD14132@1wt.eu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 10:42:25PM +0200, Willy Tarreau wrote:
> On Wed, Aug 22, 2007 at 08:15:03PM +0200, Prakash Punnoor wrote:
> > Hi,
> > 
> > even if Greg is waiting for some special invitation 
> > (http://lkml.org/lkml/2007/8/14/229), I suggest putting this patch by Ayaz on 
> > top:
> > 
> > http://lkml.org/lkml/2007/8/10/296
> 
> That's what I prepare first, but then noticed it's not in mainline.
> 
> > Perhaps Ayaz wants to give Greg the clarification he needs... :sigh:
> 
> He should, as the fix is not in mainline either :-(
> I don't think Greg asks for specific clarification, just a plain patch
> with a short commit log on its own which does not include remains of
> older mails.

Exactly, that is what I am waiting for.

And also I need the change to go into mainline first, as we can not
diverge with the -stable releases.

thanks,

greg k-h
