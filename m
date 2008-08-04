Return-Path: <linux-kernel-owner+w=401wt.eu-S1763688AbYHDV4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763688AbYHDV4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764762AbYHDVtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:49:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:50917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419AbYHDVtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:49:10 -0400
Date: Mon, 4 Aug 2008 14:46:27 -0700
From: Greg KH <gregkh@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
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
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 01/25] ftrace: remove unneeded documentation
Message-ID: <20080804214627.GA8840@suse.de>
References: <20080804203506.816201392@mini.kroah.org> <20080804212932.GA8014@suse.de> <alpine.DEB.1.10.0808041741250.5205@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808041741250.5205@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 05:42:20PM -0400, Steven Rostedt wrote:
> 
> On Mon, 4 Aug 2008, Greg KH wrote:
> 
> > 2.6.26-stable review patch.  If anyone has any objections, please let us know.
> 
> Well, I object to this patch, but I'm sure I'll be ignored.

Why?  There is no ftrace code in the 2.6.26 kernel, so why would we
worry about keeping such documentation up to date, let alone even
present at all?

Why should this matter?

thanks,

greg k-h
