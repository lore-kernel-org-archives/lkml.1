Return-Path: <linux-kernel-owner+w=401wt.eu-S1762193AbXLNG6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762193AbXLNG6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbXLNG6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:58:16 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:43132 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbXLNG6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:58:14 -0500
Date: Fri, 14 Dec 2007 07:57:13 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Len Brown <lenb@kernel.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: ACPI related Warning in 2.6.24-rc3-git2
Message-ID: <20071214065713.GC3370@ics.muni.cz>
References: <20071127150557.GA4365@ics.muni.cz> <20071128041155.GB18131@khazad-dum.debian.net> <20071128083153.GL4365@ics.muni.cz> <200712132141.23656.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712132141.23656.lenb@kernel.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 14 Dec 2007 07:57:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 09:41:23PM -0500, Len Brown wrote:
> I've udpated the BIOS on my T61 to 1.26 to match yours, but
> running 2.6.24-rc5 I don't see the issue you reported.
> 
> If it still fails for you, please send me your .config

It has been fixed in -rc4 I guess.

-- 
Luká¹ Hejtmánek
