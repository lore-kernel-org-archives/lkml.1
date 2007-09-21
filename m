Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbXIUNIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbXIUNIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbXIUNIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:08:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53174 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbXIUNIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:08:09 -0400
Date: Fri, 21 Sep 2007 14:07:52 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, dsmith@redhat.com,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070921130752.GB9431@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Denys Vlasenko <vda.linux@googlemail.com>,
	"Frank Ch. Eigler" <fche@redhat.com>, dsmith@redhat.com,
	Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20070918211324.161373216@polymtl.ca> <20070919113737.GA18177@Krystal> <y0mtzpqvk1l.fsf@ton.toronto.redhat.com> <200709192132.00873.vda.linux@googlemail.com> <20070921125819.GA13129@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921125819.GA13129@Krystal>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 08:58:19AM -0400, Mathieu Desnoyers wrote:
> Ok, I am changing it to:

As I mentioned before pleae just kill this gunk entirely as it's not needed
at all intree.  markers are already getting far too complex, I'd rather
want a simple useable version in now than trying to cater for every possible
use-case.  Once the systemtap people are ready for merging their stuff into
the kernel tree we can cater towards their needs.

