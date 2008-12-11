Return-Path: <linux-kernel-owner+w=401wt.eu-S1759940AbYLKTwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbYLKTwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932762AbYLKTvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:51:44 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47696 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932761AbYLKTvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:51:43 -0500
Date: Thu, 11 Dec 2008 14:51:42 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Paul Ready <lxtwin@homecall.co.uk>
cc: Greg KH <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <stable@kernel.org>, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 37/83] USB: add Nikon D300 camera to unusual_devs
In-Reply-To: <20081211192920.GA25494@puku.stupidest.org>
Message-ID: <Pine.LNX.4.44L0.0812111448500.15474-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008, Chris Wedgwood wrote:

> On Thu, Dec 11, 2008 at 11:14:55AM -0800, Greg KH wrote:
> 
> > 2.6.27-stable review patch.  If anyone has any objections, please
> > let us know.
> >
> > From: Paul Ready <lxtwin@homecall.co.uk>
> >
> > commit 0047ca0a45c6a481abd467fb52d2a480ffc8c6b9 upstream
> >
> > Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11685
> >
> > When A Nikon D300 camera is connected to a system it is seen in
> > /proc/bus/pci/devices but is not accessible.
> 
> 
> I can't tell from looking over the bugzilla comments if this fix is
> really the right fix or even necessary.
> 
> Is this definately the right fix?

It's not entirely clear from the Bugzilla entry that any fix is needed
at all!  In comment #14 I asked Paul Ready (the submitter) to post a
log showing what goes wrong when the entry isn't present, but he never
did.

Alan Stern

