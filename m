Return-Path: <linux-kernel-owner+w=401wt.eu-S1764160AbYEHSZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764160AbYEHSZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbYEHSZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:25:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:45443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbYEHSZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:25:35 -0400
Date: Thu, 8 May 2008 11:25:05 -0700
From: Greg KH <gregkh@suse.de>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/16] Linux 2.6.25 -stable review
Message-ID: <20080508182505.GA22308@suse.de>
References: <20080508174122.GA855@suse.de> <20080508175140.GU8474@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508175140.GU8474@1wt.eu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 07:51:41PM +0200, Willy Tarreau wrote:
> On Thu, May 08, 2008 at 10:41:22AM -0700, Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.25.2 release.
> (...)                                                  ^^^^^^^^
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.2-rc1.gz
>                                                              ^^^^^^^^
> 
> warning Greg, you wrote 2.6.25.2 everywhere it seems. It should be .3.

Ok, the updated patch is at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.3-rc1.gz

Sorry for the confusion.

greg k-h
