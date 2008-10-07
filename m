Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153AbYJGFNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbYJGFNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 01:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbYJGFNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 01:13:24 -0400
Received: from ns1.suse.de ([195.135.220.2]:34050 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbYJGFNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 01:13:23 -0400
Date: Mon, 6 Oct 2008 21:59:00 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/71] 2.6.26-stable review
Message-ID: <20081007045900.GA18235@suse.de>
References: <20081007003634.GA3055@suse.de> <02qle4hs359eq40tpuvf81i5mr72eeue5u@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02qle4hs359eq40tpuvf81i5mr72eeue5u@4ax.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 03:42:23PM +1100, Grant Coady wrote:
> On Mon, 6 Oct 2008 17:36:34 -0700, Greg KH <gregkh@suse.de> wrote:
> 
> >This is the start of the stable review cycle for the 2.6.26.6 release.
> >There are 71 patches in this series, all will be posted as a response to
> >this one.  If anyone has any issues with these being applied, please let
> >us know.  If anyone is a maintainer of the proper subsystem, and
> >wants to add a Signed-off-by: line to the patch, please respond with it.
> >
> >These patches are sent out with a number of different people on the Cc:
> >line.  If you wish to be a reviewer, please email stable@kernel.org to
> >add your name to the list.  If you want to be off the reviewer list,
> >also email us.
> >
> >Responses should be made by Wed Oct 8, 22:00:00 UTC.  Anything received
> >after that time might be too late.
> >
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.26.8-rc1.gz
> 	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Where'd you hide that file Greg?  patch-2.6.25.18-rc1.gz is there but no 
> sign of 2.6.26.6 patch

Oops, I copied the file up to the server, but forgot to move it into the
proper place.  It's patch-2.6.26.6-rc1.gz and should be there in a few
minutes.

thanks,

greg k-h
