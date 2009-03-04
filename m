Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZCDNh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZCDNh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 08:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZCDNhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:37:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbZCDNhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:37:13 -0500
Date: Wed, 4 Mar 2009 14:37:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jason Noble <nobleja@polezero.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: New HID device support
In-Reply-To: <1236173654.21288.8.camel@paradox.pz.local>
Message-ID: <alpine.LNX.2.00.0903041436210.4971@jikos.suse.cz>
References: <1236096277.26321.29.camel@paradox.pz.local>  <alpine.LNX.2.00.0903031720380.5295@jikos.suse.cz>  <1236107096.7793.1.camel@paradox.pz.local>  <alpine.LNX.2.00.0903041144310.4971@jikos.suse.cz>  <1236172544.21288.3.camel@paradox.pz.local> 
 <alpine.LNX.2.00.0903041419250.4971@jikos.suse.cz> <1236173654.21288.8.camel@paradox.pz.local>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009, Jason Noble wrote:

> Sorry to be such a bother.
> Attached .rej files if they help.
> 
> clean just untared 2.6.28.7
> 
> patching file a/drivers/hid/Kconfig
> Hunk #1 succeeded at 157 with fuzz 2.
> patching file a/drivers/hid/Makefile
> Hunk #1 FAILED at 30.
> 1 out of 1 hunk FAILED -- saving rejects to file
> a/drivers/hid/Makefile.rej
> patching file a/drivers/hid/hid-core.c
> Hunk #1 FAILED at 1271.
> 1 out of 1 hunk FAILED -- saving rejects to file
> a/drivers/hid/hid-core.c.rej
> patching file a/drivers/hid/hid-dummy.c
> Hunk #1 succeeded at 34 with fuzz 2.
> patching file a/drivers/hid/hid-ids.h
> Hunk #1 FAILED at 279.
> 1 out of 1 hunk FAILED -- saving rejects to file
> a/drivers/hid/hid-ids.h.rej
> patching file b/drivers/hid/hid-kensington.c
> paradox:/usr/src# ls a/drivers/hid/Makefile.rej 
> a/drivers/hid/Makefile.rej

Odd, the patch I sent you was based on 2.6.28.7.

You can just add the lines from .rej files manually, it's only 6 lines of 
code or so.

-- 
Jiri Kosina
SUSE Labs
