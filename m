Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbYHMQ54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbYHMQ54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYHMQ5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:57:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYHMQ5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:57:47 -0400
Date: Wed, 13 Aug 2008 09:57:14 -0700
From: Greg KH <greg@kroah.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       andi@firstfloor.org, riel@redhat.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk, arjan@infradead.org, alan@lxorguk.ukuu.org.uk,
       peterz@infradead.org, hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
Message-ID: <20080813165714.GC14529@kroah.com>
References: <1218645375.3540.71.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218645375.3540.71.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 12:36:15PM -0400, Eric Paris wrote:
> No, this is not a new security system.  This is not some great wonderful
> panacea that's going to stop every exploit.  Its a file scanner.  It's
> not bad.  It clearly can help.  This isn't just a pipe dream, I've got
> code.  Where's the problem?

Just repost your patches, with a description of what is happening with
them, taking into account the previously mentioned comments and we can
review it again :)

No problem at all, just a normal patch lifecycle...

thanks,

greg k-h
