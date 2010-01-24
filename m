Return-Path: <linux-kernel-owner+w=401wt.eu-S1752160Ab0AXXIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab0AXXIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967Ab0AXXIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:08:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46064 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab0AXXIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:08:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: [Bug #15025] Oops in ext4 driver
Date: Mon, 25 Jan 2010 00:09:34 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-ext4@vger.kernel.org
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <hE3x9c-4KZM.A.IRG.kKMXLB@chimera> <20100124224330.GA2230@uio.no>
In-Reply-To: <20100124224330.GA2230@uio.no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001250009.34529.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 January 2010, Steinar H. Gunderson wrote:
> On Sun, Jan 24, 2010 at 11:04:35PM +0100, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> 
> I'm not using 2.6.33 anymore since this bug is a showstopper to me (it's on a
> production system), so I'm unable to check if it's fixed or not.

Well, in that case I'll have to close it as 'unreproducible', because no one
else seems to be able to reproduce it.

Rafael
