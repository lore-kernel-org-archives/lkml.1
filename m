Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbXFPTGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbXFPTGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 15:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbXFPTG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 15:06:28 -0400
Received: from www.osadl.org ([213.239.205.134]:33773 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752492AbXFPTG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 15:06:27 -0400
Subject: Re: [patch-mm 00/25] High resolution timer updates and x86_64
	support - V2
From: Thomas Gleixner <tglx@linutronix.de>
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Mikko Tiihonen <mikko.tiihonen@iki.fi>
In-Reply-To: <200706161541.34032.s0348365@sms.ed.ac.uk>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
	 <200706161541.34032.s0348365@sms.ed.ac.uk>
Content-Type: text/plain
Date: Sat, 16 Jun 2007 21:06:24 +0200
Message-Id: <1182020784.8176.399.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-16 at 15:41 +0100, Alistair John Strachan wrote:
> On Saturday 16 June 2007 11:36:00 Thomas Gleixner wrote:
> > The -hrt tree at http://www.tglx.de/projects/hrtimers/2.6.22-rc4/ contains
> > also an hpet force patch series from Venki Pallipadi, but I leave this up
> > to Venki to send it mainline wards.
> 
> What's the status on the nForce "hpet force fix" (Subject: "Enable hidden HPET 
> on NVidia motherboards") that also exists? I think if one board can have its 
> HPET forced, so can another.
> 
> Last I heard we were waiting on NVIDIA to confirm whether Mikko's logic was 
> supported by specifications? Any update on this?

The full hpet force enable series is maintained by Venki and updates
should go to him. I can add the patch to my -hrt queue for testing.

	tglx


