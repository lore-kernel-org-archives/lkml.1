Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbZEXWE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbZEXWE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZEXWEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:04:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34125 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZEXWEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:04:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: 2 bugs related to suspend to disk
Date: Mon, 25 May 2009 00:04:11 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
References: <4A199A7A.3010705@gmail.com> <20090524205450.GA1693@elf.ucw.cz> <4A19C2A3.6030501@gmail.com>
In-Reply-To: <4A19C2A3.6030501@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905250004.11927.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 May 2009, Marcin Slusarz wrote:
> Pavel Machek wrote:
> > Hi!
> > 
> > 
> >> 2) "s2disk" (from suspend-0.8) suspends, but doesn't resume (and I need to mkswap && swapon -a later)
> >>
> > 
> > I'm afraid we need more details here. Is "resume" binary being ran?
> 
> Excellent question ;) - I didn't know it has to. I'll try to setup
> initramfs tomorrow.
> 
> Thanks and sorry for the noise!

However, the issue reported as 1) is not really a noise IMO. :-)

Can you please attach a full dmesg output containing these messages?

Rafael
