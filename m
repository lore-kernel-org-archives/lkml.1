Return-Path: <linux-kernel-owner+w=401wt.eu-S1030967AbXDPVCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030967AbXDPVCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030968AbXDPVCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:02:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030967AbXDPVCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:02:37 -0400
Date: Mon, 16 Apr 2007 17:01:59 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       fche@redhat.com, systemtap@sources.redhat.com
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070416210159.GA12538@redhat.com>
References: <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EEFEC.2010205@yahoo.com.au> <20070413065357.GP2986@holomorphy.com> <461F2BCB.2020200@yahoo.com.au> <20070413075142.GA23822@infradead.org> <461F3961.6030300@yahoo.com.au> <20070413081338.GA27675@infradead.org> <p73zm5857ei.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73zm5857ei.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Mon, Apr 16, 2007 at 11:36:05PM +0200, Andi Kleen wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> > and [systemtap] does a lot of really wrong things in it's
> > runtime). [...]

(Thanks, Christoph, for at least a few specifics.  Some of them have
already been dealt with in the recent past.)


> I must agree with that. Perhaps it would be good if its runtime code
> was posted to l-k at some point and reviewed in the standard way
> even when it isn't merged.

I'll let the runtime's maintainers judge whether this particular venue
would be helpful.  But is the choice of venue really an obstacle?
Everyone who cares is *already* welcome to browse the code (available
on CVS, cvsweb, tarballs - would git help?), and critique it (e.g. on
our open public mailing list or via bugzilla).

http://sourceware.org/systemtap/getinvolved.html

- FChE
