Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbXKSXMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbXKSXMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 18:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbXKSXMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 18:12:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48534 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbXKSXMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 18:12:23 -0500
Date: Mon, 19 Nov 2007 15:03:18 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, James.Bottomley@steeleye.com,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, linux-scsi@vger.kernel.org,
       torvalds@linux-foundation.org, Justin Forbes <jmforbes@linuxtx.org>,
       linux-kernel@vger.kernel.org, Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux@highpoint-tech.com, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 16/26] hptiop: avoid buffer overflow when
	returning sense data
Message-ID: <20071119230318.GB25140@kroah.com>
References: <20071119181438.617190424@mini.kroah.org> <20071119181912.GQ15425@kroah.com> <20071119183835.GE12494@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119183835.GE12494@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 11:38:35AM -0700, Matthew Wilcox wrote:
> On Mon, Nov 19, 2007 at 10:19:12AM -0800, Greg Kroah-Hartman wrote:
> > 
> > 2.6.22-stable review patch.  If anyone has any objections, please let us
> > know.
> 
> Makes sense to backport this.
> 
> Acked-by: Matthew Wilcox <willy@linux.intel.com>

Thanks for the review.

greg k-h
