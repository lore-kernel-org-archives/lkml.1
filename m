Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbXJaTJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbXJaTJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 15:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbXJaTJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:09:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbXJaTJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:09:12 -0400
Date: Wed, 31 Oct 2007 15:05:06 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
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
Message-ID: <20071031190505.GA12334@redhat.com>
References: <4726649A.5020605@garzik.org> <20071029230409.GB16943@Krystal> <472667F3.3000505@garzik.org> <20071030172442.GA4477@Krystal> <alpine.LFD.0.999.0710301044110.30120@woody.linux-foundation.org> <20071030185639.GA9077@Krystal> <alpine.LFD.0.999.0710301214300.30120@woody.linux-foundation.org> <20071030204043.GA13547@Krystal> <y0mk5p3qo8r.fsf@ton.toronto.redhat.com> <20071031092907.4a026e72@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031092907.4a026e72@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Wed, Oct 31, 2007 at 09:29:07AM -0700, Arjan van de Ven wrote:
> [...]
> > This misstates the details.  What systemtap has out-of-tree is a list
> > of kernel function names (and parameter names), not addresses.  This
> > list does change somewhat with kernel versions, but we generally keep
> > up.  We do test with vanilla kernels, and several non-RH distributors
> > test with their kernels.  It is a problem, but it is manageable.
> 
> yes so please please submit this stuff for mainline inclusion as has
> been asked quite a few times before.

OK, but I don't recall receiving a clear answer as to how you envision
this would work.  Would you support distribution of some systemtap
script files in some new subdirectory?

- FChE
