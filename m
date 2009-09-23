Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbZIWL6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbZIWL6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 07:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZIWL57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 07:57:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZIWL57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 07:57:59 -0400
Date: Wed, 23 Sep 2009 07:57:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lars.ellenberg@linbit.com,
       arjan@infradead.org, lmb@suse.de, jens.axboe@oracle.com, neilb@suse.de,
       hch@infradead.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
       akpm@linux-foundation.org, bart.vanassche@gmail.com, davej@redhat.com,
       gregkh@suse.de, kosaki.motohiro@jp.fujitsu.com,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org, Mauelshagen@redhat.com
Subject: Re: [GIT PULL] DRBD for 2.6.32
Message-ID: <20090923115751.GA11820@infradead.org>
References: <20090921144308.GG8072@barkeeper1-xen.linbit> <20090921165252.04e335b1@infradead.org> <20090921165321.GJ8072@barkeeper1-xen.linbit> <20090922072617U.fujita.tomonori@lab.ntt.co.jp> <f73f7ab80909211751p4d797556lcce5e47c3241b5ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f73f7ab80909211751p4d797556lcce5e47c3241b5ef@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 08:51:32PM -0400, Kyle Moffett wrote:
> You have to realize that this project is NOT a new one, it's been
> around quite a decent number of years (since kernel 2.2-ish).  Yes,
> the ABI is unique and has its warts, but there are a lot of things
> that depend on it.

So?  That's never been an argument.  Quite contrary, we ignored upstream
for years and fucked up out of tree but please merge anyway is almost
a counter-argument.

