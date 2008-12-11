Return-Path: <linux-kernel-owner+w=401wt.eu-S932416AbYLKTu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbYLKTu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760069AbYLKThX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:37:23 -0500
Received: from parsec.stupidest.org ([71.6.196.126]:58798 "EHLO
	parsec.stupidest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404AbYLKThV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:37:21 -0500
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2008 14:37:21 EST
Date: Thu, 11 Dec 2008 11:29:21 -0800
From: Chris Wedgwood <reviews@ml.cw.f00f.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch 37/83] USB: add Nikon D300 camera to unusual_devs
Message-ID: <20081211192920.GA25494@puku.stupidest.org>
References: <20081211190201.612240183@mini.kroah.org> <20081211191455.GK5894@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211191455.GK5894@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 11:14:55AM -0800, Greg KH wrote:

> 2.6.27-stable review patch.  If anyone has any objections, please
> let us know.
>
> From: Paul Ready <lxtwin@homecall.co.uk>
>
> commit 0047ca0a45c6a481abd467fb52d2a480ffc8c6b9 upstream
>
> Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11685
>
> When A Nikon D300 camera is connected to a system it is seen in
> /proc/bus/pci/devices but is not accessible.


I can't tell from looking over the bugzilla comments if this fix is
really the right fix or even necessary.

Is this definately the right fix?
