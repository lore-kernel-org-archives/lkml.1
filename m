Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbXC0I0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbXC0I0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 04:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbXC0I0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 04:26:41 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38871 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbXC0I0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 04:26:40 -0400
Date: Tue, 27 Mar 2007 10:27:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Wu, Bryan" <bryan.wu@analog.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Blackfin arch: add kdebug header file
Message-ID: <20070327082722.GC2031@uranus.ravnborg.org>
References: <1174903941.32691.72.camel@roc-desktop> <200703262345.09489.arnd@arndb.de> <1174966837.6966.13.camel@roc-desktop> <20070327035734.GA25883@linux-sh.org> <8bd0f97a0703262134h20bdf8dcqb1043ca176a7149c@mail.gmail.com> <20070327044914.GA26099@linux-sh.org> <8bd0f97a0703262217g16aa62d4g1221082deda0aed2@mail.gmail.com> <20070326222711.d2f42da2.randy.dunlap@oracle.com> <1174974045.6966.26.camel@roc-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174974045.6966.26.camel@roc-desktop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 01:40:45PM +0800, Wu, Bryan wrote:
> 
> Thanks for this guide line information. I will dig into it.
> 
> But in my experience, it is difficult to find right patch email
> receivers, even in the MAINTAINERS file. If there are 20 patch emails,
> we should find 20 email receivers at least and manually add them to the
> emails. This is terrible, right? Any idea?
The Cc: foo <bar@com> contained in the descrition is used to keep this info
when you found it first time.
The patchbombing tools starts to support it.

	Sam
