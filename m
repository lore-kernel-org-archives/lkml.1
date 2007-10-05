Return-Path: <linux-kernel-owner+w=401wt.eu-S1762503AbXJESA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762503AbXJESA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 14:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbXJESAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 14:00:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758793AbXJESAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 14:00:16 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Peter W. Morreale" <pmorreale@novell.com>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
Date: Fri, 5 Oct 2007 20:00:03 +0200
User-Agent: KMail/1.9.6
Cc: David Bahi <dbahi@novell.com>, mingo@elte.hu, arjan@infradead.org,
       tglx@linutronix.de, akpm@linux-foundation.org,
       Gregory Haskins <GHaskins@novell.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
References: <47060B680200006C00019B7B@sinclair.provo.novell.com> <200710051803.32016.ak@suse.de> <1191605892.31605.198.camel@hermosa.morrealenet>
In-Reply-To: <1191605892.31605.198.camel@hermosa.morrealenet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710052000.04149.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hummm, a directory appears to be protected, or DNE.  I get  "failed to
> change directory". 

Sorry typo
 
ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/fix-watchdog

-Andi

