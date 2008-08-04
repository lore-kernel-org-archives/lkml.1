Return-Path: <linux-kernel-owner+w=401wt.eu-S1770089AbYHDVnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1770089AbYHDVnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765870AbYHDVm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:42:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63059 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1770884AbYHDVmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:42:24 -0400
Date: Mon, 4 Aug 2008 17:42:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
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
In-Reply-To: <20080804212932.GA8014@suse.de>
Message-ID: <alpine.DEB.1.10.0808041741250.5205@gandalf.stny.rr.com>
References: <20080804203506.816201392@mini.kroah.org> <20080804212932.GA8014@suse.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 4 Aug 2008, Greg KH wrote:

> 2.6.26-stable review patch.  If anyone has any objections, please let us know.

Well, I object to this patch, but I'm sure I'll be ignored.

-- Steve

> 
> ------------------
> 
> 
> There is no ftrace in the 2.6.26 kernel release, so remove the
> documentation as it isn't needed.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
