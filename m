Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbYHDWCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbYHDWCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759101AbYHDWCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:02:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45697 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbYHDWCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:02:04 -0400
Date: Mon, 4 Aug 2008 18:02:00 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Greg KH <greg@kroah.com>, Justin Forbes <jmforbes@linuxtx.org>,
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
In-Reply-To: <20080804144922.393555d8.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.1.10.0808041801330.5205@gandalf.stny.rr.com>
References: <20080804203506.816201392@mini.kroah.org> <20080804212932.GA8014@suse.de> <alpine.DEB.1.10.0808041741250.5205@gandalf.stny.rr.com> <20080804144922.393555d8.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 4 Aug 2008, Randy Dunlap wrote:

> On Mon, 4 Aug 2008 17:42:20 -0400 (EDT) Steven Rostedt wrote:
> 
> > 
> > On Mon, 4 Aug 2008, Greg KH wrote:
> > 
> > > 2.6.26-stable review patch.  If anyone has any objections, please let us know.
> > 
> > Well, I object to this patch, but I'm sure I'll be ignored.
> > 
> > -- Steve
> 
> You could argue that it doesn't meet stable rules criteria, but the file
> isn't needed and can be confusing, so it makes sense to me to remove it.

I understand why Greg's pulling it. That does not mean I have to like it.

-- Steve

