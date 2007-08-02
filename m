Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbXHBWxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbXHBWxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbXHBWxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:53:40 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41263 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbXHBWxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:53:39 -0400
Date: Thu, 2 Aug 2007 17:53:37 -0500
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@steeleye.com,
       willy@debian.org, linux-scsi@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH]: PCI Error Recovery: Symbios SCSI device driver
Message-ID: <20070802225337.GK26837@austin.ibm.com>
References: <20070702183917.GJ4501@austin.ibm.com> <20070705112838.2d8c959b.akpm@linux-foundation.org> <20070705185406.GA3527@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070705185406.GA3527@parisc-linux.org>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 12:54:06PM -0600, Matthew Wilcox wrote:
> On Thu, Jul 05, 2007 at 11:28:38AM -0700, Andrew Morton wrote:
> > Well you've sent it a couple of times, and I've sent it in five more times
> > over the past year.  Once we were told "awaiting maintainer ack".
> > 
> > This situation is fairly stupid.  How about we make you the maintainer?
> 
> Last time I looked at it, I still wasn't comfortable with it.  I'm going
> to look at it again.

Please do. Its burning the proverbial hole in my pocket; I'd really
like to get this off my list of things I worry about.

> I'm fairly sure Linas doesn't want to be the sym2 maintainer.  It's
> still an ugly pile of junk that needs cleaning up.

Heh. I have no difficulty living with ugly code: its actually a 
great excuse to fix things instead of doing "real work" :-)

Rather, the menagerie of hardware I have access to is constantly 
changing; I don't have a symbios card just right now, and it might 
take a few days to even find someone who did.  Which is an incredibly
unpleasent, unrewarding activity.

--linas

