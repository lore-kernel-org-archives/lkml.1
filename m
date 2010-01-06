Return-Path: <linux-kernel-owner+w=401wt.eu-S932514Ab0AFSCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab0AFSCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932488Ab0AFSCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:02:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:44642 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932426Ab0AFSCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:02:11 -0500
Date: Wed, 6 Jan 2010 10:01:33 -0800
From: Greg KH <gregkh@suse.de>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [07/39] iwmc3200wifi: fix array out-of-boundary access
Message-ID: <20100106180133.GA23503@suse.de>
References: <20100105200259.864447568@mini.kroah.org>
 <1262746376.15653.93.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262746376.15653.93.camel@debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 10:52:56AM +0800, Zhu Yi wrote:
> On Wed, 2010-01-06 at 04:02 +0800, Greg KH wrote:
> > 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> 
> Greg, please ignore this. It is false alarm and not required for stable.
> Sorry for the noise.

Should I also drop it from the .32-stable tree as well?

thanks,

greg k-h
