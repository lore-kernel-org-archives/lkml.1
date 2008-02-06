Return-Path: <linux-kernel-owner+w=401wt.eu-S1761491AbYBFWya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491AbYBFWya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbYBFWxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:53:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51001 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630AbYBFWxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:53:48 -0500
Date: Wed, 6 Feb 2008 14:45:20 -0800
From: Greg KH <greg@kroah.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Justin M. Forbes" <jmforbes@linuxtx.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, dhaval@linux.vnet.ibm.com
Subject: Re: [patch 22/27] quicklist: Set tlb->need_flush if pages are
	remaining in quicklist 0
Message-ID: <20080206224520.GA11045@kroah.com>
References: <20080202001232.472591439@mini.kroah.org> <20080202002103.GW8368@suse.de> <Pine.LNX.4.64.0802011638330.21566@schroedinger.engr.sgi.com> <1201915720.3781.18.camel@turion.linuxtx.org> <Pine.LNX.4.64.0802011729560.21840@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802011729560.21840@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 05:30:14PM -0800, Christoph Lameter wrote:
> On Fri, 1 Feb 2008, Justin M. Forbes wrote:
> 
> > 
> > On Fri, 2008-02-01 at 16:39 -0800, Christoph Lameter wrote:
> > > NO! Wrong fix. Was dropped from mainline.
> > 
> > What is the right fix for the OOM issues with 2.6.22? Perhaps
> > http://marc.info/?l=linux-mm&m=119973653803451&w=2 should be added to
> > the queue in its place?  The OOM issue in 2.6.22 is real, and should be
> > addressed.
> 
> Indeed that is the right fix.

Can someone send it to me, in patch form so that I can apply it?  Along
with the git id of the same patch in mainline please, I can't seem to
find it.

thanks,

greg k-h
