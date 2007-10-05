Return-Path: <linux-kernel-owner+w=401wt.eu-S1763099AbXJEQDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763099AbXJEQDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbXJEQDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:03:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40589 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbXJEQD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:03:29 -0400
Date: Fri, 5 Oct 2007 11:03:22 -0500
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Tony Breeds <tony@bakeyournoodle.com>,
       Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1 -- powerpc rtas panic
Message-ID: <20071005160322.GN4338@austin.ibm.com>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <20070924123531.GC30855@shadowen.org> <20071002232819.GN4338@austin.ibm.com> <20071003002646.GD9814@bakeyournoodle.com> <1191371416.8073.1.camel@concordia> <20071003011909.GG9814@bakeyournoodle.com> <29495f1d0710041701g4ed73441ie583058c78f95857@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29495f1d0710041701g4ed73441ie583058c78f95857@mail.gmail.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 05:01:47PM -0700, Nish Aravamudan wrote:
> On 10/2/07, Tony Breeds <tony@bakeyournoodle.com> wrote:
> > On Wed, Oct 03, 2007 at 10:30:16AM +1000, Michael Ellerman wrote:
> >
> > > I realise it'll make the patch bigger, but this doesn't seem like a
> > > particularly good name for the variable anymore.
> >
> > Sure, what about?
> >
> > Clarify when RTAS logging is enabled.
> >
> > Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> 
> For what it's worth, on a different ppc64 box, this resolves a similar
> panic for me.
> 
> Tested-by: Nishanth Aravamudan <nacc@us.ibm.com>

For the reasons explained, I'd really like to nack Tony's patch.

--linas
