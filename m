Return-Path: <linux-kernel-owner+w=401wt.eu-S1752164Ab0AXXOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab0AXXOu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907Ab0AXXOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:14:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46114 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab0AXXOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:14:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Kukard <nkukard@lbsd.net>
Subject: Re: [Bug #15132] OOPS's with large initramfs
Date: Mon, 25 Jan 2010 00:15:39 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <hE3x9c-4KZM.A.xDF.8JMXLB@chimera> <4B5CCFC5.1090002@lbsd.net>
In-Reply-To: <4B5CCFC5.1090002@lbsd.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201001250015.39428.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 January 2010, Nigel Kukard wrote:
> Verified. I have tested this as far back as 2.6.30 with the same problem
> with "very" large initramfs's.

So this is not a recent regression, but a bug that has been there for a long
time.  Dropping from the list.

Thanks,
Rafael
