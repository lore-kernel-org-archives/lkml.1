Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbYHEPXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbYHEPXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbYHEPXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:23:35 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:39112 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYHEPXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:23:34 -0400
Message-ID: <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <Pine.LNX.4.64.0808051140150.6309@anakin>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>
    <43318.166.70.238.45.1217792210.squirrel@webmail.wolfmountaingroup.com>
    <1217808849.2328.43.camel@localhost.localdomain>
    <58898.166.70.238.45.1217816372.squirrel@webmail.wolfmountaingroup.com>
    <4897070E.5050509@s5r6.in-berlin.de>
    <38332.166.70.238.45.1217860413.squirrel@webmail.wolfmountaingroup.com>
    <Pine.LNX.4.64.0808051140150.6309@anakin>
Date: Tue, 5 Aug 2008 09:02:45 -0600 (MDT)
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Cc: jmerkey@wolfmountaingroup.com,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Josh Boyer" <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 4 Aug 2008, jmerkey@wolfmountaingroup.com wrote:
>> yet) and clean up this list of issues.   ULONG, etc. is Microsoft syntax
>> for cross platform compatibility.  Since this is a LINUX SPECIFIC PATCH,
>
> You're aware that the Microsoft assumption
>
>     typedef unsigned long  ULONG
>
> is not compatible with 64-bit platforms in the rest of the world?
>
> Gr{oetje,eeting}s,
>
> 						Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 --
> geert@linux-m68k.org


No I was not, but I am now.  At any rate, I removed the Microsoft-isms
from the code.  I can cut yet another patch for git6, but git5 was there
-- GPL2 and all.  How about putting in into the kernel guys -- :-)

Jeff



