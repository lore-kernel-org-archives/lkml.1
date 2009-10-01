Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbZJAPg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbZJAPg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZJAPg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:36:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbZJAPg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:36:27 -0400
Date: Thu, 1 Oct 2009 08:23:15 -0700
From: Greg KH <gregkh@suse.de>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.35
Message-ID: <20091001152315.GA5957@suse.de>
References: <20090924173758.GA17077@kroah.com>
 <4ABBF03C.1070309@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABBF03C.1070309@imap.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 12:18:36AM +0200, Tilman Schmidt wrote:
> Greg,
> 
> I notice the mismerge of mainline commit
> 170ebf85160dd128e1c4206cc197cce7d1424705
> "bas_gigaset: correctly allocate USB interrupt transfer buffer"
> into 2.6.27-stable isn't fixed in this release yet. Is that just
> a timing problem, or do you still need anything from me?

It was a timing problem, I should be resolving it now and queueing up
the fix for the next .27 release.

thanks for your patience.

greg k-h
