Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYJWPzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYJWPzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYJWPy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:54:58 -0400
Received: from kroah.org ([198.145.64.141]:53313 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752469AbYJWPy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:54:57 -0400
Date: Thu, 23 Oct 2008 08:51:33 -0700
From: Greg KH <greg@kroah.com>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Eugene Teo <eteo@redhat.com>, Justin Forbes <jmforbes@linuxtx.org>,
       linux-kernel@vger.kernel.org, Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Jake Edge <jake@lwn.net>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>
Subject: Re: [stable] [patch 00/17] 2.6.27-stable review
Message-ID: <20081023155133.GA4394@kroah.com>
References: <20081018183334.GA14035@suse.de> <20081023010126.GB30920@zod.rchland.ibm.com> <20081023045345.GB6949@kroah.com> <20081023063339.11c99044@zod.rchland.ibm.com> <20081023153348.GA3995@kroah.com> <20081023114734.483e9724@zod.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023114734.483e9724@zod.rchland.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 11:47:34AM -0400, Josh Boyer wrote:
> 
> No.  I said that already.  I'm just trying to clarify what the
> expectations are for -stable because when it first started stuff liek
> that wasn't taken.  Also, it seems nobody has updated the documentation
> file as -stable has evolved.  I'd be more than happy to correct that,
> but I just need to get a feel for where -stable is at before I can do
> that.

Adding the "we accept new device ids and quirks" would be good to have
added to the file, I have no problem with that.

thanks,

greg k-h
