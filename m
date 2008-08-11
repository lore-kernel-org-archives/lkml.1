Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbYHKUjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbYHKUjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYHKUi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:38:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55871 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbYHKUi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:38:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #11273] 2.6.27-rc1: softcursor behaviour changed
Date: Mon, 11 Aug 2008 22:41:55 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@suse.cz>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.-1._CjnIB@albercik> <alpine.LFD.1.10.0808111041060.3462@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808111041060.3462@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808112241.56699.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 11 of August 2008, Linus Torvalds wrote:
> 
> On Sun, 10 Aug 2008, Rafael J. Wysocki wrote:
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> 
> The revert is now in my tree as 3838f59fc2ea9821f3ea13adb555bfc6ea43c74c.

Thanks, closed.

Rafael
