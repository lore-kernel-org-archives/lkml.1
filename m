Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbZIWLck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbZIWLck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 07:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZIWLcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 07:32:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:42329 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZIWLci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 07:32:38 -0400
Date: Wed, 23 Sep 2009 13:32:32 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Jamie Lokier <jamie@shareable.org>, Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "hch@infradead.org" <hch@infradead.org>
Subject: Re: fanotify as syscalls
Message-ID: <20090923133232.5577688d@infradead.org>
In-Reply-To: <200909230939.34003.tvrtko.ursulin@sophos.com>
References: <20090912094110.GB24709@ioremap.net>
	<200909221731.34717.agruen@suse.de>
	<alpine.DEB.2.00.0909220836200.10460@makko.or.mcafeemobile.com>
	<200909230939.34003.tvrtko.ursulin@sophos.com>
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

On Wed, 23 Sep 2009 09:39:33 +0100
Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:

> Lived with it because there was no other option. We used LSM while it
> was available for modules but then it was taken away. 

... at which point you could have submitted your LSM module for
inclusion... you'd be the first (and only?) Anti Virus vendor that
would be in the mainline kernel.. speaking of competitive advantage,
coming out of the box in all distributions.

sadly this road hasn't been chosen....



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
