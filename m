Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYJBRMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYJBRMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 13:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYJBRMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 13:12:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:38210 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbYJBRMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 13:12:16 -0400
Date: Thu, 2 Oct 2008 19:11:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002171155.GN19428@kernel.dk>
References: <20081001200034.65eb67d6@infradead.org> <20081001215638.3a65134c.akpm@linux-foundation.org> <20081002060553.3cd32c5c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002060553.3cd32c5c@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02 2008, Arjan van de Ven wrote:
> On Wed, 1 Oct 2008 21:56:38 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 1 Oct 2008 20:00:34 -0700 Arjan van de Ven
> > <arjan@infradead.org> wrote:
> > 
> > > Subject: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
> > 
> > You proposed this a while back
> 
> one year ago to be precise
> 
> >and it didn't happen and I forget
> > why and the changelog doesn't mention any of that?
> 
> Jens didn't like the APi I used back then.
> Since then the kernel grew (by Jens) a clean API to do the same...

Actually I don't think I changed anything, did I? IIRC, I just pointed
you at the API :-)

-- 
Jens Axboe

