Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbZIUOw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbZIUOw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbZIUOw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:52:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:36950 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbZIUOwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:52:55 -0400
Date: Mon, 21 Sep 2009 16:52:52 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lmb@suse.de,
       jens.axboe@oracle.com, neilb@suse.de, hch@infradead.org,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       drbd-dev@lists.linbit.com, akpm@linux-foundation.org,
       bart.vanassche@gmail.com, davej@redhat.com, gregkh@suse.de,
       kosaki.motohiro@jp.fujitsu.com, kyle@moffetthome.net,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org, Mauelshagen@redhat.com
Subject: Re: [GIT PULL] DRBD for 2.6.32
Message-ID: <20090921165252.04e335b1@infradead.org>
In-Reply-To: <20090921144308.GG8072@barkeeper1-xen.linbit>
References: <20090918200803.GM23126@kernel.dk>
	<20090919141334N.fujita.tomonori@lab.ntt.co.jp>
	<20090919220232.GB31849@suse.de>
	<20090921223815U.fujita.tomonori@lab.ntt.co.jp>
	<20090921144308.GG8072@barkeeper1-xen.linbit>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 16:43:08 +0200
Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> We can choose whatever user-kernel interface you like,
> and change it with every dot release --
> we'd just need to add additional compat code into
> the drbdsetup userland binary.

uh no.

the kernel<->userspace ABI is stable.
we don't go about randomly changing it
(extending it is fine obviously)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
