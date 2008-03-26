Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbYCZJgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbYCZJgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 05:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbYCZJgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 05:36:32 -0400
Received: from lazybastard.de ([212.112.238.170]:43285 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbYCZJgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 05:36:32 -0400
Date: Wed, 26 Mar 2008 10:36:12 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, jirislaby@gmail.com, viro@ZenIV.linux.org.uk,
       joe@perches.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups - formatting only
Message-ID: <20080326093612.GA22847@logfs.org>
References: <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu> <20080325134556.GA10424@elte.hu> <20080325.161142.65862968.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080325.161142.65862968.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 March 2008 16:11:42 -0700, David Miller wrote:
> >                                     errors   lines of code   errors/KLOC
> > drivers/mtd/devices/block2mtd.c         10             490          20.4
> 
> Ingo, this is devolving into a "code I maintain is great, code you
> maintain sucks, checkpatch says so" kind of discussion, please stop.
> 
> You're not making any friends by making your arguments this way.

To be fair, block2mtd does suck, even conceptually.  But that would
digress too far.

Jörn

-- 
Rules of Optimization:
Rule 1: Don't do it.
Rule 2 (for experts only): Don't do it yet.
-- M.A. Jackson
