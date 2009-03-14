Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbZCNPvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbZCNPvx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 11:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbZCNPvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 11:51:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:54128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbZCNPva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 11:51:30 -0400
Date: Sat, 14 Mar 2009 08:38:58 -0700
From: Greg KH <gregkh@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
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
Message-ID: <20090314153858.GA5637@suse.de>
References: <20090314000508.803142980@mini.kroah.org> <20090314000739.667137229@mini.kroah.org> <20090314124620.GA23968@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090314124620.GA23968@lst.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 01:46:20PM +0100, Christoph Hellwig wrote:
> On Fri, Mar 13, 2009 at 05:05:15PM -0700, Greg KH wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us kno
> 
> Why would you even consider this for stable?  It's purely documenting
> a couple of constants.

I added it to make the patches after this easier to handle and apply.

thanks,

greg k-h
