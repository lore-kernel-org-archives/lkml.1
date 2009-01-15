Return-Path: <linux-kernel-owner+w=401wt.eu-S932341AbZAOU7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbZAOU7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764208AbZAOUPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:15:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56763 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348AbZAOUPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:15:20 -0500
Message-ID: <496F988D.2010601@zytor.com>
Date: Thu, 15 Jan 2009 12:11:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan-Benedict Glaw <jbglaw@lug-owl.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Jiri Kosina <jkosina@suse.cz>, Adam Osuchowski <adwol@zonk.pl>,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Is 386 processor still supported?
References: <20090108120338.6b8b4567@zonk.pl> <alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz> <1231424025.11687.447.camel@twins> <alpine.LNX.1.10.0901081518070.5377@jikos.suse.cz> <1231424833.11687.452.camel@twins> <20090108150448.2393aeb0@lxorguk.ukuu.org.uk> <20090108151046.GK18120@elte.hu> <alpine.LFD.1.10.0901130047160.10547@ftp.linux-mips.org> <20090115123614.GR11087@lug-owl.de> <alpine.LFD.1.10.0901151309420.5737@ftp.linux-mips.org> <20090115133252.28c36adb@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0901151353530.5737@ftp.linux-mips.org> <20090115142541.5a7711b1@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0901151437230.5737@ftp.linux-mips.org>
In-Reply-To: <alpine.LFD.1.10.0901151437230.5737@ftp.linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> 
>  You can actually escape the FPU emulator if you have a proper computer 
> (an i386/80287 combo, anyone? ;) -- we've got it right actually :) ), but 
> the rest and overall I agree with you.  And I think i386-class cores can 
> be still seen in some embedded applications, so there may be non-epsilon 
> interest yet.
> 

I did run Linux way back when on a 16 MHz 80386/80387 combo.  All the 
memory was on the ISA bus, too.  It ran at a whopping 0.57 BogoMIPS, and 
we still used it as a server.

	-hpa
