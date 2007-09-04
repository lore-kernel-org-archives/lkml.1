Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbXIDWIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbXIDWIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 18:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXIDWII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 18:08:08 -0400
Received: from 83-216-141-215.markhi700.adsl.metronet.co.uk ([83.216.141.215]:3990
	"EHLO mx.hindley.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbXIDWIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 18:08:07 -0400
Date: Tue, 4 Sep 2007 23:08:03 +0100
From: Mark Hindley <mark@hindley.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: hang with CONFIG_MCYRIXIII
Message-ID: <20070904220803.GB3242@hindley.org.uk>
References: <20070902110401.GB4790@hindley.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070902110401.GB4790@hindley.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Having established that the oops was not the cause of the hangs I have
been observing with MCYRIXIII, could anyone suggest ways to track down
if this is a compiler or kernel bug?

I have just complied latest git (with tcp_input.c oops fix)

With CONFIG_MCYRIXIII I got a hang with empty logs and nothing on the
serial line, sysrq unresponsive after about 2 hours

CONFIG_M586MMX has been solid

gcc (GCC) 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)
Copyright (C) 2006 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

GNU ld (GNU Binutils for Debian) 2.17.90.20070812
Copyright 2007 Free Software Foundation, Inc.
This program is free software; you may redistribute it under the terms of
the GNU General Public License version 3 or (at your option) a later version.
This program has absolutely no warranty.
Mark Hindley

Thanks,

Mark
