Return-Path: <linux-kernel-owner+w=401wt.eu-S1761494AbYEMUiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494AbYEMUiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758578AbYEMUiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:38:06 -0400
Received: from ns2.suse.de ([195.135.220.15]:44232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758296AbYEMUiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:38:05 -0400
Date: Tue, 13 May 2008 13:37:05 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 25/37] sparc: Fix mremap address range validation.
Message-ID: <20080513203705.GA488@suse.de>
References: <20080513200453.064446337@mini.kroah.org> <20080513201229.GZ31167@suse.de> <alpine.LFD.1.10.0805131327130.3019@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805131327130.3019@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 01:28:32PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 13 May 2008, Greg KH wrote:
> >
> > From: David S. Miller <davem@davemloft.net>
> > 
> > Just like mmap, we need to validate address ranges regardless
> > of MAP_FIXED.
> 
> Hmm. I don't have this one in my tree. Is it obsoleted by the other 
> patches I do have, or what? If so, some comment about that would be nice.

Odd, I missed that.  David, did you just forget to send this one?

thanks,

greg k-h
