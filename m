Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbYCVSch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbYCVSch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 14:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYCVSc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 14:32:29 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41050 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbYCVSc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 14:32:28 -0400
Date: Sat, 22 Mar 2008 11:27:56 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Lennert Buytenhek <buytenh@wantstofly.org>,
       Riku Voipio <riku.voipio@movial.fi>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 33/76] futex: runtime enable pi and robust functionality
Message-ID: <20080322182755.GD23462@sequoia.sous-sol.org>
References: <20080321224250.144333319@sous-sol.org> <20080321224400.674465387@sous-sol.org> <alpine.LFD.1.00.0803220833040.3781@apollo.tec.linutronix.de> <20080322161918.GA6367@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080322161918.GA6367@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Heiko Carstens (heiko.carstens@de.ibm.com) wrote:
> > 504e75d0ed3389747e40a4aaa4b1f4e569576665
> > Author: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Date:   Thu Mar 20 17:33:38 2008 +0100
> > 
> >     [S390] futex: let futex_atomic_cmpxchg_pt survive early functional tests.
> 
> Yes, forgot to add -stable to the cc list. Sorry.

Got it, thanks.
-chris
