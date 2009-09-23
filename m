Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbZIWV5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbZIWV5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 17:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZIWV5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 17:57:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46107 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbZIWV5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:57:15 -0400
Date: Wed, 23 Sep 2009 17:56:58 -0400
From: "hch@infradead.org" <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Jamie Lokier <jamie@shareable.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "hch@infradead.org" <hch@infradead.org>
Subject: Re: fanotify as syscalls
Message-ID: <20090923215658.GA30096@infradead.org>
References: <20090912094110.GB24709@ioremap.net> <200909221731.34717.agruen@suse.de> <alpine.DEB.2.00.0909220836200.10460@makko.or.mcafeemobile.com> <200909230939.34003.tvrtko.ursulin@sophos.com> <20090923133232.5577688d@infradead.org> <1253721097.2890.3.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253721097.2890.3.camel@dhcp231-106.rdu.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 11:51:37AM -0400, Eric Paris wrote:
> And users would be left in a situation between choosing an LSM which
> actually does in provable ways increase security and using an AV
> scanner.

Sounds like a good thing, no?

