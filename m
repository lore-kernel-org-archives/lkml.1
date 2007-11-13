Return-Path: <linux-kernel-owner+w=401wt.eu-S1761775AbXKMS7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761775AbXKMS7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbXKMS7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:59:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:41852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbXKMS7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:59:45 -0500
Date: Tue, 13 Nov 2007 10:59:24 -0800
From: Greg KH <gregkh@suse.de>
To: Philip Mucci <mucci@cs.utk.edu>
Cc: eranian@hpl.hp.com, William Cohen <wcohen@redhat.com>, akpm@osdl.org,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Perfmon <perfmon@napali.hpl.hp.com>, Andi Kleen <andi@firstfloor.org>,
       perfmon2-devel@lists.sourceforge.net,
       OSPAT devel <ospat-devel@cs.utk.edu>,
       papi list <ptools-perfapi@cs.utk.edu>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071113185924.GA22748@suse.de>
References: <20071107003454.GA13374@kroah.com> <20071109120627.60ec9ab4.akpm@linux-foundation.org> <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 10:47:45AM -0800, Philip Mucci wrote:
> Hi folks,
>
> Well, I can say the mood here at supercomputing'07 is pretty somber in 
> regards to the latest exchange of messages regarding the perfmon patches. 

"somber"?

Why?

We (a number of the kernel developers) want to see the perfmon code make
it into the kernel tree, unfortunatly, in the current state it is in,
that's not going to happen.

Andi specified a way that this can happen, just refactor your patches
into smaller bits that can be reviewed and applied.

If you, or anyone else has any questions about this, please let us know.
So far, I have not seen any response to his message, so I'm guessing
that the perfmon developers either are off working on this, or don't
care.

And if they don't care, then yes, I agree with your "somber" feeling...

thanks,

greg k-h
