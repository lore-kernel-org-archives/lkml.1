Return-Path: <linux-kernel-owner+w=401wt.eu-S1762576AbYD0Mu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762576AbYD0Mu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 08:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbYD0MuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 08:50:14 -0400
Received: from mjg.x.mythic-beasts.com ([93.93.128.6]:42993 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbYD0MuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 08:50:13 -0400
X-Greylist: delayed 2722 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Apr 2008 08:50:13 EDT
Date: Sun, 27 Apr 2008 12:55:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Message-ID: <20080427115536.GA20043@srcf.ucam.org>
References: <200804181856.m3IIuKd4007403@hera.kernel.org> <480F7C11.8040302@zytor.com> <20080427100901.GC3891@ucw.cz> <200804271331.18940.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804271331.18940.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 01:31:17PM +0200, Rafael J. Wysocki wrote:
> On Sunday, 27 of April 2008, Pavel Machek wrote:
> > I believe vbetool and thus s2ram uses vm86, too.
> 
> Well, I think so too. Matthew?

Yes, though I don't think any of them use these internal flags.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
