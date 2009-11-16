Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbZKPM7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbZKPM7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZKPM7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:59:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbZKPM7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:59:34 -0500
Date: Mon, 16 Nov 2009 13:59:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Soeren Sonnenburg <sonne@debian.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, olh@suse.de,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] mouse button 1 emulation for mac_hid
In-Reply-To: <20091114054246.GF4463@core.coreip.homeip.net>
Message-ID: <alpine.LRH.2.00.0911161358240.31913@twin.jikos.cz>
References: <1257762531.7245.23.camel@no> <20091114054246.GF4463@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009, Dmitry Torokhov wrote:

> > I am not sure what the future of mac_hid is (the source says will be
> > removed, but since 9 years). In case it stays in kernel the attached
> > patch adds support for mouse button 1 emulation. If this driver stays in
> > the kernel I would also suggest to rename it - it is not mac specific (I
> > am using this on a netbook).
> > 
> > Rationale? Broken touchpads, within linux unsupported (multi-)touchpads
> > where click and hold + moving the mouse does not work (yet?).
> 
> I would rather fix the touchpads so they work properly than pile more
> quirks in kernel.

Hi Dmitry,

in exactly what way are you planning to "fix the touchpads"?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

