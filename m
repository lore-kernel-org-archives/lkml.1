Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbZEHFTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbZEHFTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 01:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZEHFSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 01:18:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:51323 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbZEHFSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 01:18:54 -0400
Date: Thu, 7 May 2009 22:13:42 -0700
From: Greg KH <gregkh@suse.de>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Chris Frey <cdfrey@foursquare.net>, chrisw@sous-sol.org,
       smfrench@gmail.com, jlayton@redhat.com, linux-kernel@vger.kernel.org,
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
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/58] 2.6.29.3-stable review
Message-ID: <20090508051342.GA11425@suse.de>
References: <20090506215017.GA21981@kroah.com> <20090507172301.GA28595@foursquare.net> <20090507221313.GA7126@suse.de> <4A03B5FD.4020907@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A03B5FD.4020907@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 10:03:01AM +0530, Suresh Jayaraman wrote:
> Greg KH wrote:
> > On Thu, May 07, 2009 at 01:23:04PM -0400, Chris Frey wrote:
> >> On Wed, May 06, 2009 at 02:50:17PM -0700, Greg KH wrote:
> >>> This is the start of the stable review cycle for the 2.6.29.3 release.
> >>> There are 58 patches in this series, all will be posted as a response to
> >>> this one.
> >> Maybe I'm missing something, but I don't see any of
> >> the fs/cifs/connect.c security fixes from commits such as
> >> f083def68f84b04fe3f97312498911afce79609e.  I was hoping this would make
> >> it into 2.6.29.3.
> > 
> > No one sent them to stable@kernel.org for inclusion :(
> 
> Sorry, the patches were sent to cifs mailing list for
> consensus/discussion and -stable inclusion request has not happened
> (though Steve Cced stable the summary email with his ACK). I'm sending
> the patches right away.. and hope it's not too late for 29.3

Yes, it's too late for .3, that review cycle started yesterday and will
be released tomorrow.

> I have based the patches on top of 2.6.29.2.

Thanks, we can always start a new review cycle on Friday with these if
needed.

thanks,

greg k-h
