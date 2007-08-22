Return-Path: <linux-kernel-owner+w=401wt.eu-S933400AbXHVU4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400AbXHVU4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759317AbXHVUzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:55:55 -0400
Received: from 1wt.eu ([62.212.114.60]:2268 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759288AbXHVUzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:55:53 -0400
Date: Wed, 22 Aug 2007 22:42:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2.6.20.17 review 35/58] forcedeth bug fix: realtek phy
Message-ID: <20070822204225.GD14132@1wt.eu>
References: <20070822083844.%N@1wt.eu> <20070822084026.%N@1wt.eu> <200708222015.04141.prakash@punnoor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708222015.04141.prakash@punnoor.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 08:15:03PM +0200, Prakash Punnoor wrote:
> Hi,
> 
> even if Greg is waiting for some special invitation 
> (http://lkml.org/lkml/2007/8/14/229), I suggest putting this patch by Ayaz on 
> top:
> 
> http://lkml.org/lkml/2007/8/10/296

That's what I prepare first, but then noticed it's not in mainline.

> Perhaps Ayaz wants to give Greg the clarification he needs... :sigh:

He should, as the fix is not in mainline either :-(
I don't think Greg asks for specific clarification, just a plain patch
with a short commit log on its own which does not include remains of
older mails.

I'm holding up the patch until I get confirmation that it is *at least*
queued for mainline, otherwise it will definitely be missing from
mainline.

Thanks Prakash for the pointers above.
Willy

