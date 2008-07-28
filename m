Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYG1QM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYG1QM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYG1QMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:12:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:39794 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbYG1QMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:12:13 -0400
Date: Mon, 28 Jul 2008 08:39:19 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, peterz@infradead.org,
       mingo <mingo@redhat.com>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] locking: fix mutex @key parameter kernel-doc notation
Message-ID: <20080728153919.GB30206@kroah.com>
References: <20080724165842.fbae8993.randy.dunlap@oracle.com> <20080728145209.GI18144@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728145209.GI18144@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 04:52:09PM +0200, Ingo Molnar wrote:
> 
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix @key parameter to mutex_init() and one of its callers.
> > 
> > Warning(linux-2.6.26-git11//drivers/base/class.c:210): No description 
> > found for parameter 'key'
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> applied to tip/core/urgent, thanks Randy. Greg, any objections?

No objection from me:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
