Return-Path: <linux-kernel-owner+w=401wt.eu-S935219AbXHIQuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935219AbXHIQuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939392AbXHIQu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:50:28 -0400
Received: from ns2.suse.de ([195.135.220.15]:60068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939204AbXHIQu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:50:26 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Cal Peake <cp@absolutedigital.net>
Subject: Re: [PATCH] [8/12] x86_64: Use global flag to disable broken local apic timer on AMD CPUs.
Date: Thu, 9 Aug 2007 18:50:18 +0200
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070809241.425881000@suse.de> <20070809124136.00A6C14F3B@wotan.suse.de> <Pine.LNX.4.64.0708091245070.31931@lancer.cnet.absolutedigital.net>
In-Reply-To: <Pine.LNX.4.64.0708091245070.31931@lancer.cnet.absolutedigital.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091850.18741.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >  	/*
> >  	 * The local apic timer can be disabled via the kernel
> >  	 * commandline or from the test above. Register the lapic
> 
> Andi, just noticed that the comment above needs to be updated now.

Too late now. I can do that as a follow up patch. It'll be hardly 
a showstopper.

-Andi
