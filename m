Return-Path: <linux-kernel-owner+w=401wt.eu-S1765270AbYHDVed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765270AbYHDVed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762643AbYHDVdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:33:43 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:42269 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764994AbYHDVdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:33:42 -0400
Date: Mon, 4 Aug 2008 23:33:30 +0200
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
       Thomas Renninger <trenn@suse.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature shutdown
Message-ID: <20080804213330.GA18123@gamma.logic.tuwien.ac.at>
References: <200807241727.41715.trenn@suse.de> <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain> <200807251319.12786.trenn@suse.de> <alpine.LFD.1.10.0807250948320.3884@localhost.localdomain> <alpine.LFD.1.10.0808011706350.3011@localhost.localdomain> <20080801223657.GD23558@khazad-dum.debian.net> <20080802054204.GB12646@srcf.ucam.org> <20080802143833.GC14069@khazad-dum.debian.net> <20080802144452.GA25565@gamma.logic.tuwien.ac.at> <20080802145141.GA14626@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080802145141.GA14626@khazad-dum.debian.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nerique,

On Sa, 02 Aug 2008, Henrique de Moraes Holschuh wrote:
> Yes, it is a call to hwclock.  It recently started to cause lockups on my
> ThinkPad T43 too (it is a regression of some sort, either in hwclock or the

Thanks a lot for that bit, didn't know and was already scared that my
laptop was nearing its end. 

> But the thermal hang is something else entirely.  You have at least two
> different bugs causing you grief.

We will see how rc2++ behave. Thanks a lot.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
LISTOWEL (n.)
The small mat on the bar designed to be more absorbent than the bar,
but not as absorbent as your elbows.
			--- Douglas Adams, The Meaning of Liff
