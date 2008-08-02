Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbYHBOpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbYHBOpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 10:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYHBOpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 10:45:03 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:60368 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYHBOpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 10:45:01 -0400
Date: Sat, 2 Aug 2008 16:44:52 +0200
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
       Thomas Renninger <trenn@suse.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature shutdown
Message-ID: <20080802144452.GA25565@gamma.logic.tuwien.ac.at>
References: <200807241727.41715.trenn@suse.de> <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain> <200807251319.12786.trenn@suse.de> <alpine.LFD.1.10.0807250948320.3884@localhost.localdomain> <alpine.LFD.1.10.0808011706350.3011@localhost.localdomain> <20080801223657.GD23558@khazad-dum.debian.net> <20080802054204.GB12646@srcf.ucam.org> <20080802143833.GC14069@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080802143833.GC14069@khazad-dum.debian.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

(please Cc or leave linux-acpi on the recipient list, thanks)

sorry to chime in so late, but I am experiencing something similar: My
Acer TravelMate 3012 sometimes shuts down at the boot sequence telling
me something like "critical temperature" (more I cannot read, it is
quite fast in turning of the laptop.

That happens at strange times (couldn't find a pattern), and after being
switched off for hours, so the laptop is definitely not hot.

Using 2.6.27-rc1, but I am relatively sure that I had similar things in
the past.

There something else strange, no idea if that is related, sometimes it
just hangs after 
	Setting the clock.
That is a message of Debian/sid and probably calls hwclock or something
similar.

If all that is something else, sorry for disturbing.

If you need .config, dmesg, acpidump, dmidecode, whatever, let me know.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
You step in the stream,
But the water has moved on.
This page is not here.
                       --- Windows Error Haiku
