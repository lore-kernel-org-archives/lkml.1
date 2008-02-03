Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbYBCS0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbYBCS0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 13:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbYBCS0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 13:26:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40742 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYBCS0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 13:26:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: wakeup code translated to .c
Date: Sun, 3 Feb 2008 19:24:44 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080130120111.GB22820@elf.ucw.cz> <200802031857.02422.rjw@sisk.pl> <20080203181648.GA1629@elf.ucw.cz>
In-Reply-To: <20080203181648.GA1629@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802031924.44592.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 3 of February 2008, Pavel Machek wrote:
> Hi!
> 
> > > This version works on 32-bit, and builds on 64-bit (but I'm pretty
> > > sure it does not work. 32-bit code probably needs to go into rm/....)
> > > 
> > 
> > Do you have an updated version or is this the latest one?
> 
> I'm glad you ask ;-). Here's reasonably-recent version (I have
> slightly cleaner one, but it got obscured by 2.6.24-git merge), I
> eventually got it to work on 64-bit, by reusing trampoline.S code.

Thanks, I'll have a look and test it a bit.

Rafael
