Return-Path: <linux-kernel-owner+w=401wt.eu-S1031403AbXEDRjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031403AbXEDRjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031413AbXEDRjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:39:36 -0400
Received: from canuck.infradead.org ([209.217.80.40]:50136 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031403AbXEDRjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:39:35 -0400
Date: Fri, 4 May 2007 10:02:46 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <clameter@engr.sgi.com>,
       "David S. Miller" <davem@davemloft.net>, Andi Kleen <ak@suse.de>,
       "Luck, Tony" <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: incoming
Message-ID: <20070504170246.GA23069@kroah.com>
References: <20070502150252.7ddf67ac.akpm@linux-foundation.org> <20070504133728.GA19460@kroah.com> <20070504091434.106ad04d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504091434.106ad04d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 09:14:34AM -0700, Andrew Morton wrote:
> On Fri, 4 May 2007 06:37:28 -0700 Greg KH <greg@kroah.com> wrote:
> 
> > On Wed, May 02, 2007 at 03:02:52PM -0700, Andrew Morton wrote:
> > > - One little security patch
> > 
> > Care to cc: linux-stable with it so we can do a new 2.6.21 release with
> > it if needed?
> > 
> 
> Ah.  The patch affects security code, but it doesn't actually address any
> insecurity.  I didn't think it was needed for -stable?

Ah, ok, I read "security" as fixing a insecure problem, my mistake :)

thanks,

greg k-h
