Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYBCX7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYBCX7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 18:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbYBCX7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 18:59:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42119 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbYBCX7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:59:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: wakeup code translated to .c
Date: Mon, 4 Feb 2008 00:57:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080130120111.GB22820@elf.ucw.cz> <200802032333.02821.rjw@sisk.pl> <20080203235722.GI2799@elf.ucw.cz>
In-Reply-To: <20080203235722.GI2799@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802040057.24429.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 4 of February 2008, Pavel Machek wrote:
> Hi!
> 
> > - Could the real mode directory be called just "real-mode" or something like
> >   this ("rm" is not very meaningful :-))?
> > 
> > Apart from the above and the _WAKEUP hacks mentioned elsewhere, it looks okay
> > (from a very high orbit).
> 
> Wakeup hacks? You mean those #ifdef WAKEUP in video code?

Yes.

[I'm not sure if that could be done differently, though.  Surely hpa knows ;-)]

Rafael
