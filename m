Return-Path: <linux-kernel-owner+w=401wt.eu-S1030456AbXCVKsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030456AbXCVKsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 06:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030461AbXCVKsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 06:48:24 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:42142 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030456AbXCVKsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 06:48:21 -0400
Date: Thu, 22 Mar 2007 11:50:22 +0100
From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suspend to disk bug 2.6.21-rc2-git1
Message-ID: <20070322105022.GB3621@mail.muni.cz>
References: <20070305132331.GF3693@mail.muni.cz> <20070310221639.GC2674@elf.ucw.cz> <20070321213007.GA3637@mail.muni.cz> <20070321223908.GI6057@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070321223908.GI6057@elf.ucw.cz>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@fi.muni.cz
X-Muni-Envelope-To: linux-kernel@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 22 Mar 2007 11:48:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 11:39:08PM +0100, Pavel Machek wrote:
> > > > I'm not sure what version did exacly caused susped to disk problems but
> > > > anyway, in 2.6.21-rc2-git1, suspend to disk breaks ACPI. ACPI events do not
> > > > even emit ACPI interrupts. Suspend to ram works nicely.
> > > 
> > > Is 2.6.21-latest better?  There were many problems in suspend area,
> > > hopefully they are slowly being fixed...
> > 
> > I've found out that only platform method is working. reboot method does not.
> 
> Try this one.

It seems to be OK. Thanks.

-- 
Luká¹ Hejtmánek
