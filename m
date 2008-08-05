Return-Path: <linux-kernel-owner+w=401wt.eu-S1758991AbYHEJln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbYHEJln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 05:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbYHEJlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 05:41:32 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:43653 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbYHEJlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 05:41:31 -0400
Date: Tue, 5 Aug 2008 11:41:28 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: jmerkey@wolfmountaingroup.com
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Josh Boyer <jwboyer@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
In-Reply-To: <38332.166.70.238.45.1217860413.squirrel@webmail.wolfmountaingroup.com>
Message-ID: <Pine.LNX.4.64.0808051140150.6309@anakin>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>
 <43318.166.70.238.45.1217792210.squirrel@webmail.wolfmountaingroup.com>
 <1217808849.2328.43.camel@localhost.localdomain>
 <58898.166.70.238.45.1217816372.squirrel@webmail.wolfmountaingroup.com>
 <4897070E.5050509@s5r6.in-berlin.de> <38332.166.70.238.45.1217860413.squirrel@webmail.wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008, jmerkey@wolfmountaingroup.com wrote:
> yet) and clean up this list of issues.   ULONG, etc. is Microsoft syntax
> for cross platform compatibility.  Since this is a LINUX SPECIFIC PATCH,

You're aware that the Microsoft assumption

    typedef unsigned long  ULONG

is not compatible with 64-bit platforms in the rest of the world?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
