Return-Path: <linux-kernel-owner+w=401wt.eu-S1762906AbXJMSyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762906AbXJMSyS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbXJMSyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:54:05 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2151 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbXJMSyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:54:04 -0400
Date: Sat, 13 Oct 2007 20:53:30 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/8] m68k: ignore restart_syscall
In-Reply-To: <20071013123412.923788313@mail.of.borg>
Message-ID: <Pine.LNX.4.64.0710132049190.1819@scrub.home>
References: <20071013123123.085686856@mail.of.borg> <20071013123412.923788313@mail.of.borg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 13 Oct 2007, Geert Uytterhoeven wrote:

> m68k: ignore restart_syscall, which is not needed on m68k.

It's somewhat needed, but nobody has gotten around to actually implement 
it yet...

bye, Roman
