Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZCHWdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZCHWdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 18:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZCHWdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 18:33:33 -0400
Received: from kroah.org ([198.145.64.141]:49744 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754607AbZCHWdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 18:33:33 -0400
Date: Sun, 8 Mar 2009 15:33:04 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jouni Malinen <j@w1.fi>, Sujith <m.sujith@gmail.com>,
       Sujith <Sujith.Manoharan@atheros.com>,
       Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Christoph Hellwig <hch@infradead.org>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: Staging, place holder for better company/community development
	model
Message-ID: <20090308223304.GB11513@kroah.com>
References: <43e72e890903022314o44ae710u834d6207403fd4a2@mail.gmail.com> <1236514065.4205.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236514065.4205.9.camel@johannes.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 01:07:45PM +0100, Johannes Berg wrote:
> On Mon, 2009-03-02 at 23:14 -0800, Luis R. Rodriguez wrote:
> 
> > If we should take this approach -- should we send patches for wireless
> > staging to John, or Greg? It would still be "crap" so I don't expect
> > John to accept to help maintain crap but what if its crap with a clear
> > defined path to un-crap land?
> 
> FWIW, I would MUCH prefer if the staging crap never passed any official
> mailing lists.

What do you mean by this?  You don't ever want to see any staging
patches on any mailing lists?  That doesn't sound helpful.

I can provide a simple procmail rule if you really don't like this kind
of thing, but that seems pretty extreme...
