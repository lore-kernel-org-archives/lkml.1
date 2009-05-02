Return-Path: <linux-kernel-owner+w=401wt.eu-S1760825AbZEBV6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825AbZEBV6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 17:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759512AbZEBV5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 17:57:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:60925 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758687AbZEBV5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 17:57:53 -0400
Date: Sat, 2 May 2009 14:50:11 -0700
From: Greg KH <gregkh@suse.de>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.28.10
Message-ID: <20090502215011.GA17424@suse.de>
References: <20090502200413.GA7287@kroah.com> <49FCBF1C.1060603@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49FCBF1C.1060603@pardus.org.tr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 12:46:04AM +0300, Ozan Çağlayan wrote:
> Greg KH wrote:
> > I'm announcing the release of the 2.6.28.10 kernel.
> >
> > It contains a wide range of bugfixes, and all users of the 2.6.28 kernel
> > series are strongly encouraged to upgrade.  Especially due to the CVE
> > issues that are fixed here.
> >
> > NOTE, this is the LAST update of the 2.6.28 kernel series, so all users
> > are very strongly encouraged to upgrade to the 2.6.29 series at this
> > point in time!
> >   
> Hi,
> 
> Is there a policy about the end-of-life of kernel releases? 2.6.27 is at
> .21 while
> .10 is the last update for 2.6.28.

"Policy"?  heh, no :)

It has been repeated many times that the 2.6.27 tree is going to be
maintained for a long time.  That is why I am still doing .27 releases,
and will be for quite a while.

The other -stable branches are moving just like they always have been,
nothing is new there.

Hope this helps,

greg k-h
