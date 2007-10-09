Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbXJIUpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbXJIUpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 16:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbXJIUpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 16:45:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35819 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbXJIUpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 16:45:06 -0400
Date: Tue, 9 Oct 2007 13:41:12 -0700
From: Greg KH <greg@kroah.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Greg KH <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Roel Kluin <12o3l@tiscali.nl>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 08/12] NLM: Fix a circular lock dependency in
	lockd
Message-ID: <20071009204112.GA11411@kroah.com>
References: <20071008180406.052382073@mini.kroah.org> <20071008180629.GI7627@kroah.com> <470A8C7D.70303@tiscali.nl> <1191942028.8739.3.camel@heimdal.trondhjem.org> <20071009151341.GA5925@suse.de> <1191943677.8739.13.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191943677.8739.13.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 11:27:57AM -0400, Trond Myklebust wrote:
> 
> Please see the attachment.

Thanks, I've applied this to the tree.

greg k-h
