Return-Path: <linux-kernel-owner+w=401wt.eu-S932593Ab0AFS2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab0AFS2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932562Ab0AFS2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:28:19 -0500
Received: from kroah.org ([198.145.64.141]:56496 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542Ab0AFS2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:28:18 -0500
Date: Wed, 6 Jan 2010 10:27:39 -0800
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>
Cc: Zhu Yi <yi.zhu@intel.com>, "stable@kernel.org" <stable@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>
Subject: Re: [stable] [07/39] iwmc3200wifi: fix array out-of-boundary access
Message-ID: <20100106182739.GB27674@kroah.com>
References: <20100105200259.864447568@mini.kroah.org>
 <1262746376.15653.93.camel@debian>
 <20100106180133.GA23503@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100106180133.GA23503@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 10:01:33AM -0800, Greg KH wrote:
> On Wed, Jan 06, 2010 at 10:52:56AM +0800, Zhu Yi wrote:
> > On Wed, 2010-01-06 at 04:02 +0800, Greg KH wrote:
> > > 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> > 
> > Greg, please ignore this. It is false alarm and not required for stable.
> > Sorry for the noise.
> 
> Should I also drop it from the .32-stable tree as well?

I've dropped it for now to be safe.

thanks,

greg k-h
