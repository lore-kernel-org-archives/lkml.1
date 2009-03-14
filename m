Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbZCNTWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbZCNTWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 15:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbZCNTWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 15:22:11 -0400
Received: from verein.lst.de ([213.95.11.210]:58639 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359AbZCNTWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 15:22:10 -0400
Date: Sat, 14 Mar 2009 20:18:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: Greg KH <gregkh@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch 07/96] documnt FMODE_ constants
Message-ID: <20090314191806.GA3428@lst.de>
References: <20090314000508.803142980@mini.kroah.org> <20090314000739.667137229@mini.kroah.org> <20090314124620.GA23968@lst.de> <20090314153858.GA5637@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090314153858.GA5637@suse.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.127 () BAYES_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 08:38:58AM -0700, Greg KH wrote:
> On Sat, Mar 14, 2009 at 01:46:20PM +0100, Christoph Hellwig wrote:
> > On Fri, Mar 13, 2009 at 05:05:15PM -0700, Greg KH wrote:
> > > 2.6.27-stable review patch.  If anyone has any objections, please let us kno
> > 
> > Why would you even consider this for stable?  It's purely documenting
> > a couple of constants.
> 
> I added it to make the patches after this easier to handle and apply.

Ok, fine with me.

