Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbXJaTu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbXJaTu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 15:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbXJaTuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:50:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47470 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbXJaTuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:50:14 -0400
Date: Wed, 31 Oct 2007 12:49:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       "William L. Irwin" <wli@holomorphy.com>,
       Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] Create kinst/ or ki/ directory ?
Message-ID: <20071031124926.787757f1@laptopd505.fenrus.org>
In-Reply-To: <20071031190505.GA12334@redhat.com>
References: <4726649A.5020605@garzik.org>
	<20071029230409.GB16943@Krystal>
	<472667F3.3000505@garzik.org>
	<20071030172442.GA4477@Krystal>
	<alpine.LFD.0.999.0710301044110.30120@woody.linux-foundation.org>
	<20071030185639.GA9077@Krystal>
	<alpine.LFD.0.999.0710301214300.30120@woody.linux-foundation.org>
	<20071030204043.GA13547@Krystal>
	<y0mk5p3qo8r.fsf@ton.toronto.redhat.com>
	<20071031092907.4a026e72@laptopd505.fenrus.org>
	<20071031190505.GA12334@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007 15:05:06 -0400
"Frank Ch. Eigler" <fche@redhat.com> wrote:

> Hi -
> 
> On Wed, Oct 31, 2007 at 09:29:07AM -0700, Arjan van de Ven wrote:
> > [...]
> > > This misstates the details.  What systemtap has out-of-tree is a
> > > list of kernel function names (and parameter names), not
> > > addresses.  This list does change somewhat with kernel versions,
> > > but we generally keep up.  We do test with vanilla kernels, and
> > > several non-RH distributors test with their kernels.  It is a
> > > problem, but it is manageable.
> > 
> > yes so please please submit this stuff for mainline inclusion as has
> > been asked quite a few times before.
> 
> OK, but I don't recall receiving a clear answer as to how you envision
> this would work.  Would you support distribution of some systemtap
> script files in some new subdirectory?

yes absolutely.
