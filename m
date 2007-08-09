Return-Path: <linux-kernel-owner+w=401wt.eu-S940726AbXHIORs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940726AbXHIORs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940644AbXHIORW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:17:22 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55018
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940637AbXHIORV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:17:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.23-rc2-mm1: no bcm43xx
Date: Thu, 9 Aug 2007 16:16:49 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <200708091624.58160.rjw@sisk.pl>
In-Reply-To: <200708091624.58160.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091616.49237.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2007 16:24:57 Rafael J. Wysocki wrote:
> On Thursday, 9 August 2007 10:51, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc2/2.6.23-rc2-mm1/
> > 
> > - Added new NFSD development tree as git-nfsd ("J.  Bruce Fields"
> >   <bfields@fieldses.org>)
> > 
> > - There is a new e1000 driver in git-netdev-all, called e1000e.  I'm sure
> >   the developers would like it tested.  Please cc netdev@vger.kernel.org on
> >   any reports.
> > 
> > - I dropped the SSB patches due to various catastrophes and they are being
> >   redone.  But git-wireless.patch had some dependencies upon SSB which were
> >   plugged with some nasty bandaids.  So there are some kconfig warnings whcih
> >   come out of there.  Don't worry about it for now.
> 
> This caused the bcm43xx driver to be unselectable. :-(

That is expected. It will be fixed when we managed to merge all
that stuff properly together. Hopefully next mm.

-- 
Greetings Michael.
