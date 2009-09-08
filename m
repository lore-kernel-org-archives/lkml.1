Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbZIHTEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbZIHTEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbZIHTEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:04:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58438 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbZIHTEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:04:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [Bug #13949] Cryptoloop stuck I/O issue on partition or loopback device
Date: Tue, 8 Sep 2009 21:05:13 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Felix Blyakher <felixb@sgi.com>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera> <20090907152553.GA21768@infradead.org> <alpine.DEB.2.00.0909081029050.7636@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0909081029050.7636@p34.internal.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909082105.13124.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 September 2009, Justin Piszcz wrote:
> 
> On Mon, 7 Sep 2009, Christoph Hellwig wrote:
> 
> > On Sun, Sep 06, 2009 at 08:11:51PM +0200, Rafael J. Wysocki wrote:
> >> This message has been generated automatically as a part of a report
> >> of regressions introduced between 2.6.29 and 2.6.30.
> >>
> >> The following bug entry is on the current list of known regressions
> >> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> >> be listed and let me know (either way).
> >
> > While this still isn't fixed it has been tracked down to a regression
> > in the loop driver.  Care to adjust the subject?
> >
> 
> Unsure how to edit on the kernel bugtracker but updating this thread to 
> correct the subject.

I've changed the subject and moved the bug to I/O & storage.

Thanks,
Rafael
