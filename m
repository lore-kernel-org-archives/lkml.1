Return-Path: <linux-kernel-owner+w=401wt.eu-S1764611AbYHDWFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764611AbYHDWFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYHDWFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:05:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37376 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbYHDWFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:05:44 -0400
Date: Mon, 4 Aug 2008 14:49:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
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
Message-Id: <20080804144922.393555d8.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.1.10.0808041741250.5205@gandalf.stny.rr.com>
References: <20080804203506.816201392@mini.kroah.org>
	<20080804212932.GA8014@suse.de>
	<alpine.DEB.1.10.0808041741250.5205@gandalf.stny.rr.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008 17:42:20 -0400 (EDT) Steven Rostedt wrote:

> 
> On Mon, 4 Aug 2008, Greg KH wrote:
> 
> > 2.6.26-stable review patch.  If anyone has any objections, please let us know.
> 
> Well, I object to this patch, but I'm sure I'll be ignored.
> 
> -- Steve

You could argue that it doesn't meet stable rules criteria, but the file
isn't needed and can be confusing, so it makes sense to me to remove it.


> > 
> > ------------------
> > 
> > 
> > There is no ftrace in the 2.6.26 kernel release, so remove the
> > documentation as it isn't needed.
> > 
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
