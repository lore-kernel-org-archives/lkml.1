Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbXD0Nt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbXD0Nt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbXD0Nt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:49:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbXD0Nt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:49:28 -0400
Message-ID: <4631FEEE.4070005@redhat.com>
Date: Fri, 27 Apr 2007 09:47:26 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: bryan.wu@analog.com, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/33] 2.6.20-stable review
References: <20070426165445.GA1898@kroah.com>	 <1177668954.5969.18.camel@roc-desktop> <9a8748490704270405w1b02119dic0422a0ce661357c@mail.gmail.com>
In-Reply-To: <9a8748490704270405w1b02119dic0422a0ce661357c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> 
> The normal way -stable works is that it tracks the latest 2.6.x kernel
> that has been released.
> Now that 2.6.21 has been released, a final flush of the patch queue
> against 2.6.20 is done, that will be 2.6.20.10, and then -stable will
> switch to 2.6.21.y, when 2.6.22 comes out a final 2.6.21.y is made and
> then it's off to track 2.6.22
> 

The older stable version is usually maintained for a while after the next
major release comes out. How long that is can vary. I would personally like
to see 2.6.20 continue for a while, at least until 2.6.21.x is judged stable
enough (that could be a long time.)
