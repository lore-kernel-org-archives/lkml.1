Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbZFEPAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbZFEPAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZFEO7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:59:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbZFEO7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:59:50 -0400
Date: Fri, 5 Jun 2009 10:59:41 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Luck Tony <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] kmap_types: convert most arches to a single header
	file
Message-ID: <20090605145941.GA12216@bombadil.infradead.org>
References: <4A280BB0.4030805@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A280BB0.4030805@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 11:00:16AM -0700, Randy Dunlap wrote:
> Cc: Kyle McMartin <kyle@mcmartin.ca>

Acked-by: Kyle McMartin <kyle@mcmartin.ca>
