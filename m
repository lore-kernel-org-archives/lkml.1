Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZALRtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZALRtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZALRtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:49:36 -0500
Received: from thunk.org ([69.25.196.29]:50852 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbZALRtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:49:36 -0500
Date: Mon, 12 Jan 2009 12:49:27 -0500
From: Theodore Tso <tytso@mit.edu>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Greg KH <gregkh@suse.de>, David Miller <davem@davemloft.net>,
       jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org, corbet@lwn.net
Subject: Re: Who wrote 2.6.28
Message-ID: <20090112174927.GG21793@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Wang Chen <wangchen@cn.fujitsu.com>, Greg KH <gregkh@suse.de>,
	David Miller <davem@davemloft.net>, jaswinderlinux@gmail.com,
	linux-kernel@vger.kernel.org, corbet@lwn.net
References: <496224D7.2030109@cn.fujitsu.com> <3f9a31f40901090609n29b4e36dwe6fff7fdfc705c7e@mail.gmail.com> <20090109.141124.154196743.davem@davemloft.net> <20090110213121.GF31579@mit.edu> <20090110220004.GA5875@suse.de> <496AA506.20900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496AA506.20900@cn.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 10:03:50AM +0800, Wang Chen wrote:
> 
> Ted, when you said this, do you mean the page "all_whole.html"?
> If so, my explanation is that this page lists all the people who
> ever worked for TLF since 2.6.13 age.
> Is there any mistake?

I can't remember for certain which one I was looking at; it might have
been 2._6_26_whole_line.html or 2.6.27's whole_line.html:

# No.1 Stephen Hemminger <shemminger@linux-foundation.org> 42263
# No.2 Linus Torvalds <torvalds@linux-foundation.org> 1165
# No.3 Theodore Ts'o <tytso@mit.edu> 42
# No.4 Chris Wright <chrisw@osdl.org> 35
# No.5 Christoph Lameter <cl@linux-foundation.org> 14

Of the above technically only Linus Torvalds is an _employee_ of the
Linux Foundation.  I'm technically an employee of IBM, but I'm on loan
to the Linux Foundation.

One of the things which get confusing is that people's employers
change over time, so if you are mapping engineers to company, it's not
enough to use just an e-mail address and map it to a company name;
ideally you need to take an e-mail address and/or name and date range,
and then map that to a compay name.  For example Alan Cox was
previously at Red Hat, but he will be changing employers to Intel as
of some date in January, 2009, but he will be keeping his e-mail
address.

							- Ted
