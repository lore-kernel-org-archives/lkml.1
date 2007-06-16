Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbXFPOlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbXFPOlu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 10:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbXFPOln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 10:41:43 -0400
Received: from mcr-smtp-001.bulldogdsl.com ([212.158.248.7]:1296 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756068AbXFPOlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 10:41:42 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch-mm 00/25] High resolution timer updates and x86_64 support - V2
Date: Sat, 16 Jun 2007 15:41:33 +0100
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Mikko Tiihonen <mikko.tiihonen@iki.fi>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
In-Reply-To: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706161541.34032.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 June 2007 11:36:00 Thomas Gleixner wrote:
> The -hrt tree at http://www.tglx.de/projects/hrtimers/2.6.22-rc4/ contains
> also an hpet force patch series from Venki Pallipadi, but I leave this up
> to Venki to send it mainline wards.

What's the status on the nForce "hpet force fix" (Subject: "Enable hidden HPET 
on NVidia motherboards") that also exists? I think if one board can have its 
HPET forced, so can another.

Last I heard we were waiting on NVIDIA to confirm whether Mikko's logic was 
supported by specifications? Any update on this?

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
