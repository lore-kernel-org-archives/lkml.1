Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbYLKTy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbYLKTy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbYLKTyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:54:19 -0500
Received: from kroah.org ([198.145.64.141]:52747 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755159AbYLKTyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:54:18 -0500
Date: Thu, 11 Dec 2008 11:53:25 -0800
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Latest staging stuff
Message-ID: <20081211195325.GA7978@kroah.com>
References: <43e72e890812111146n1b9b0d07y99cd8cea3d72e952@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890812111146n1b9b0d07y99cd8cea3d72e952@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 11:46:41AM -0800, Luis R. Rodriguez wrote:
> Greg,
> 
> Where do I get stuff to send patches against your latest staging? I
> thought it would be your staging git tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> 
> But this doesn't seem to have the latest. I actually see more later stuff on:
> 
> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/staging/

Yes, that is correct.

> What is the difference between what you maintain in these?

The old staging.git tree is obsolete, I need to go delete the thing,
sorry about that.

> I take it there is no actual git tree that is not just a directory
> with patches for staging huh? It seems I would have to apply all the
> patches in gregkh/gregkh-2.6/patches/staging/ and then send stuff
> against it.

Yes, that is exactly the thing to do.

Or, you can grab the linux-next tree and send me patches against that,
as it includes my staging patch set inside of it and it is resynced
every night.

So, if you like git, you might want to stick with linux-next and use
that to send me staging patches.

Hope this helps,

greg k-h
