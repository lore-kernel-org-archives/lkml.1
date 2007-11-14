Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbXKNHli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbXKNHli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 02:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXKNHla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 02:41:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59186 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbXKNHla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 02:41:30 -0500
Date: Tue, 13 Nov 2007 23:40:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Greg KH <gregkh@suse.de>, Philip Mucci <mucci@cs.utk.edu>,
       eranian@hpl.hp.com, William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Perfmon <perfmon@napali.hpl.hp.com>, Andi Kleen <andi@firstfloor.org>,
       perfmon2-devel@lists.sourceforge.net,
       OSPAT devel <ospat-devel@cs.utk.edu>,
       papi list <ptools-perfapi@cs.utk.edu>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-Id: <20071113234027.7fbee986.akpm@linux-foundation.org>
In-Reply-To: <18234.41652.199520.31261@cargo.ozlabs.ibm.com>
References: <20071107003454.GA13374@kroah.com>
	<20071109120627.60ec9ab4.akpm@linux-foundation.org>
	<20071109213829.GC28276@kroah.com>
	<p73abpl2654.fsf@bingen.suse.de>
	<20071113151718.GA3804@erda.amd.com>
	<4739C42F.8030208@redhat.com>
	<20071113175545.GD4319@frankl.hpl.hp.com>
	<53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu>
	<20071113185924.GA22748@suse.de>
	<20071113120728.4342e7d7.akpm@linux-foundation.org>
	<18234.41652.199520.31261@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 18:24:36 +1100 Paul Mackerras <paulus@samba.org> wrote:

> Andrew Morton writes:
> 
> > I was hoping that after the round of release-and-review which Stephane,
> > Andi and I did about twelve months ago that we were on track to merge the
> > perfmon codebase as-offered.  But now it turns out that the sentiment is
> > that the code simply has too many bells-and-whistles to be acceptable.
> 
> Whose sentiment?

Andi and hch, maybe others I've forgotten about.

> I've had a bit of a look at it today together with David Gibson.  Our
> impression is that the latest version is a lot cleaner and simpler
> than it used to be.  I'm also reading Stephane's technical report
> which describes the interface, and whilst I'm only part-way through
> it, I haven't seen anything yet which strikes me as unnecessary or
> overly complicated.

Yes, that's quite possible.  I don't know how up-to-date people's
knowledge is.  I know I haven't looked seriously at the code in around
twelve months.

Let's get it on the wires as outlined and take a look at it all.
