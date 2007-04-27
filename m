Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbXD1RFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbXD1RFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161877AbXD1RFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:05:32 -0400
Received: from ns.suse.de ([195.135.220.2]:60210 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416AbXD1RFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:05:05 -0400
Date: Fri, 27 Apr 2007 16:55:16 -0700
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cbou@mail.ru, linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [ANNOUNCE] battery2 git repository
Message-ID: <20070427235516.GB24476@suse.de>
References: <20070426232902.GA10423@zarina> <20070427164629.fde8ffca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427164629.fde8ffca.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 04:46:29PM -0700, Andrew Morton wrote:
> On Fri, 27 Apr 2007 03:29:02 +0400
> Anton Vorontsov <cbou@mail.ru> wrote:
> 
> > You can get it using "git clone --reference linux-2.6 \
> > git://git.infradead.org/users/cbou/battery2-2.6.git" command.
> 
> I added this to the -mm lineup.
> 
> Welcome to git.  This means that nobody looks at your code any more and you
> get free rein to experiment with interesting innovations in VFS, MM and
> security in the mainline kernel (well, not really - Linus does squint at
> the diffstat).
> 
> But we do have a general problem that code which travels the
> developer->git->mainline route is not getting sufficient review.  Please be
> aware of this, and be as pushy as you like in sending your changes out to
> mailing lists (including linux-kernel) to get them reviewed.
> 
> If you don't think they have received adequate review then send them again,
> and shout at people - we'd all admire that.

Heh.  Yes, feel free to send me these patches to review, I don't mind.

thanks,

greg k-h
