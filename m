Return-Path: <linux-kernel-owner+w=401wt.eu-S1751134AbXCJVv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134AbXCJVv2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 16:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbXCJVv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 16:51:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:52031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbXCJVv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 16:51:27 -0500
Date: Sat, 10 Mar 2007 13:49:02 -0800
From: Greg KH <gregkh@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/20] 2.6.20-stable review
Message-ID: <20070310214902.GA3351@suse.de>
References: <20070310061603.GA31412@kroah.com> <20070310062313.GA853@kroah.com> <45F3269D.8010601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F3269D.8010601@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 04:43:57PM -0500, Chuck Ebbert wrote:
> Greg KH wrote:
> > On Fri, Mar 09, 2007 at 10:16:03PM -0800, Greg KH wrote:
> >> This is the start of the stable review cycle for the 2.6.20.3 release.
> > 
> > Oh, the rolled up patch is at:
> > 	kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.20.3-rc1.gz
> 
> You mean:
> 
> kernel.org/pub/linux/kernel/v2.6/incr/patch-2.6.20.3-rc1.gz
> 
> ?

Oops, I put it in the wrong directory, sorry about that.  I've now moved
it to the testing/ subdir.

thanks,

greg k-h
