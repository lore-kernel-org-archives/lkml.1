Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544Ab0BERFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:05:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54508 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521Ab0BERFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:05:09 -0500
Date: Fri, 5 Feb 2010 08:57:51 -0800
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Jiri Kosina <jkosina@suse.cz>, Alan Cox <alan@linux.intel.com>,
       Vikram Pandita <vikram.pandita@ti.com>,
       Christian Pellegrin <chripell@fsfe.org>, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] obsolete config in kernel source (HARD_PPS)
Message-ID: <20100205165751.GB10922@suse.de>
References: <20100205134718.GC7077@faui49.informatik.uni-erlangen.de> <20100205143937.5081eacb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205143937.5081eacb@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 02:39:37PM +0000, Alan Cox wrote:
> > 	There are a bunch of files in the current linux tree checking
> > for CONFIG_HARD_PPS which isn't in KConfig neither any other media of
> > setting it as far as I can tell and has been like this for ages.
> 
> HARD_PPS isn't yet upstream but having the hooks there is useful in the
> meantime

Ok, I'll ignore this patch.

thanks,

greg k-h
