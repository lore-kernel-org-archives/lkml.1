Return-Path: <linux-kernel-owner+w=401wt.eu-S1751535AbXCMMn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbXCMMn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbXCMMn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:43:26 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:37063 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbXCMMnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:43:25 -0400
Date: Tue, 13 Mar 2007 13:45:11 +0100
From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suspend to disk bug 2.6.21-rc2-git1
Message-ID: <20070313124511.GC3553@mail.muni.cz>
References: <20070305132331.GF3693@mail.muni.cz> <20070310221639.GC2674@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070310221639.GC2674@elf.ucw.cz>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 147.251.54.96
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 13 Mar 2007 13:43:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 11:16:39PM +0100, Pavel Machek wrote:
> Hi!
> 
> > I'm not sure what version did exacly caused susped to disk problems but
> > anyway, in 2.6.21-rc2-git1, suspend to disk breaks ACPI. ACPI events do not
> > even emit ACPI interrupts. Suspend to ram works nicely.
> 
> Is 2.6.21-latest better?  There were many problems in suspend area,
> hopefully they are slowly being fixed...

2.6.21-rc3-git with platform (previous method was reboot) method works OK.

-- 
Luká¹ Hejtmánek
