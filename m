Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbZLODFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbZLODFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 22:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbZLODFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 22:05:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759092AbZLODFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 22:05:12 -0500
Date: Tue, 15 Dec 2009 14:05:02 +1100
From: Neil Brown <neilb@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the md-current tree with Linus'
 tree
Message-ID: <20091215140502.5edd6678@notabene.brown>
In-Reply-To: <200912141127.27019.arnd@arndb.de>
References: <20091214102428.f50557a0.sfr@canb.auug.org.au>
	<200912141127.27019.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 11:27:26 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> Neil, still have  a tree where I track patches to fs/compat_ioctl.c
> that have not yet been merged. If you just keep the half in your
> own files and drop the ones in fs/compat_ioctl.c, I'll submit that
> next time. You can also adapt the patch again to the new contents
> and remove the four above to save me that work.
> 
> I didn't want to remove them from fs/compat_ioctl.c before they
> got added to md.c, in order to keep bisection correct.
> 
> 	Arnd


I had already rebased that patch on the lasted from Linus and asked him to
pull again.
He how seems to have done that, so md should be up-to-date in -linus,
including the compat_ioctl stuff.
If you would like to double check that it matches what you expect, that would
be great.

Thanks,
NeilBrown
