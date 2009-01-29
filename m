Return-Path: <linux-kernel-owner+w=401wt.eu-S1759608AbZA2XKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbZA2XKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZA2XKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:10:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45222 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbZA2XKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:10:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
Date: Fri, 30 Jan 2009 00:10:14 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Matt Carlson <mcarlson@broadcom.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <20090129222247.GA13861@xw6200.broadcom.net> <alpine.DEB.2.00.0901291730030.5149@parag-desktop>
In-Reply-To: <alpine.DEB.2.00.0901291730030.5149@parag-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901300010.15747.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009, Parag Warudkar wrote:
> 
> On Thu, 29 Jan 2009, Matt Carlson wrote:
> 
> > FWIW, I can suspend and resume using the latest linux-2.6 kernel
> > on a machine with a similar chip here.  The problem doesn't seem to
> > affect all Broadcom devices.
> 
> It is failing for me on HP xw6600 workstation, if that helps in any way.

Hm, I have an xw4600 nearby, will try tomorrow.

Thanks,
Rafael
