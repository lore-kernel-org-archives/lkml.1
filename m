Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbXBEGz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbXBEGz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 01:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbXBEGz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 01:55:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:35006 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752751AbXBEGz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 01:55:27 -0500
X-Authenticated: #14349625
Subject: Re: 2.6.19.2 oops after resume from ram (corruption?)
From: Mike Galbraith <efault@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070204154335.GB2032@elf.ucw.cz>
References: <1170241008.6512.10.camel@Homer.simpson.net>
	 <20070204154335.GB2032@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 07:55:18 +0100
Message-Id: <1170658518.6543.7.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-04 at 16:43 +0100, Pavel Machek wrote:
> Hi!
> 
> > I received the below upon first poke of firefox icon after a resume.  
> > 
> > See attachment (evolution refuses to inline it).
> 
> Is it repeatable? You may want to try with smaller set of
> modules... prism54 is quite unusual...

Nope, rogue event... so far.  Prism54 is my wlan card.  (useless dang
thing, can't convince it to do encryption)

	-Mike

