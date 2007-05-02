Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbXEBHqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbXEBHqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030847AbXEBHqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:46:13 -0400
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:40047 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752960AbXEBHqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:46:10 -0400
Date: Wed, 2 May 2007 09:46:07 +0200
From: Martin Mares <mj@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
Message-ID: <mj+md-20070502.074425.20911.nikam@ucw.cz>
References: <463698D5.20102@zytor.com> <46369A8F.1050809@garzik.org> <46369B03.1060500@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46369B03.1060500@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I mean the SVGA chip-specific code.

Feel free to kill it, anybody using these cards is very unlikely to run
a 2.6.x kernel.

However, the BIOS mode switching is still useful.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
Hi! I'm a .signature virus! Copy me into your ~/.signature to help me spread!
