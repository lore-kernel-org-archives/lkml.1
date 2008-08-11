Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYHKQqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYHKQqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYHKQqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:46:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50655 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbYHKQqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:46:32 -0400
Date: Mon, 11 Aug 2008 09:45:48 -0700
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-ID: <20080811164548.GB8038@kroah.com>
References: <20080715213108.GB23331@redhat.com> <20080717070103.GA21961@kroah.com> <20080717212040.GB13252@redhat.com> <20080717223222.GA28016@kroah.com> <20080808215153.GA16729@redhat.com> <20080809010741.GA26036@kroah.com> <20080811141231.GA6103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811141231.GA6103@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 10:12:34AM -0400, Jason Baron wrote:
> > What's up with the "2" versions?
> > 
> 
> "2" here is the second bitmask as explained previously.

Great, thanks for doing this, can you put this description in the code
so it doesn't come up again?  :)

thanks,

greg k-h
