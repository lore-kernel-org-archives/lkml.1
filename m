Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbXJBNwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbXJBNwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbXJBNwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:52:09 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:44468 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbXJBNwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:52:07 -0400
Message-ID: <fa686aa40710020652u38a8ee1dj3e65ba1764de999e@mail.gmail.com>
Date: Tue, 2 Oct 2007 07:52:04 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: [PATCH v2 2/6] Sysace: Use the established platform bus api
Cc: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Christoph Hellwig" <hch@infradead.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071002063523.GM5303@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
	 <20070930225707.2476.24080.stgit@trillian.cg.shawcable.net>
	 <20070930230557.GA17654@infradead.org>
	 <fa686aa40709301633q32c7bd9epf07b5a78acb4380e@mail.gmail.com>
	 <20071001115954.GD5303@kernel.dk> <1191304710.6310.97.camel@pasglop>
	 <20071002063523.GM5303@kernel.dk>
X-Google-Sender-Auth: 1c607bd245d14b37
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Oct 02 2007, Benjamin Herrenschmidt wrote:
> >
> > On Mon, 2007-10-01 at 13:59 +0200, Jens Axboe wrote:
> > > Just send a fixup patch for that, I'll add your series to the block tree
> > > for 2.6.24.
> >
> > It's actually better off living in the powerpc tree I think as it's
> > really about adding support for a new powerpc platform and somewhat
> > needs to sync with other things in there. Unless you really want the
> > whole thing in your tree :-)
>
> I already included it yesterday, it'll go up once 2.6.24 opens. Let me
> know if you want me to rip it out, though.

No, it's safe.  Nothing will break if one goes in before the other.
Please keep it in.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
