Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbXKNAYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbXKNAYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbXKNAYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:24:25 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:43519 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbXKNAYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:24:24 -0500
Date: Tue, 13 Nov 2007 19:24:23 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 2/9] AOUT: Mark arches that support A.OUT format [try #6]
Message-ID: <20071114002423.GB22964@fattire.cabal.ca>
References: <20071114001832.27662.8437.stgit@warthog.procyon.org.uk> <20071114001842.27662.66081.stgit@warthog.procyon.org.uk> <20071114002346.GA22964@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114002346.GA22964@fattire.cabal.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 07:23:46PM -0500, Kyle McMartin wrote:
> On Wed, Nov 14, 2007 at 12:18:42AM +0000, David Howells wrote:
> > Mark arches that support A.OUT format by including the following in their
> > master Kconfig files:
> > 
> > 	config ARCH_SUPPORTS_AOUT
> > 		def_bool y
> > 
> ...
> > Signed-off-by: David Howells <dhowells@redhat.com>
> >
> 
> big Acked-by: Kyle McMartin <kyle@mcmartin.ca> to the whole set
> arch-dependant set...
> 

except parisc doesn't support a.out :P

cheers,
	kyle
