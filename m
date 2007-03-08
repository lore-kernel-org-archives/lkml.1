Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbXCHUJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbXCHUJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbXCHUJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:09:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50854 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbXCHUJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:09:54 -0500
Date: Thu, 8 Mar 2007 21:08:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Pavel Machek <pavel@ucw.cz>,
       Jens Axboe <jens.axboe@oracle.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       michael@ellerman.id.au
Subject: Re: [PATCH 0/2] Repair pci_restore_state when used with device resets
Message-ID: <20070308200809.GA10088@elte.hu>
References: <45ED8A12.5040803@intel.com> <m1ejo1elj6.fsf@ebiederm.dsl.xmission.com> <45EEE8CF.1060803@intel.com> <45EEEC2C.5090609@intel.com> <m1649cdfas.fsf@ebiederm.dsl.xmission.com> <20070307185317.5601d452.akpm@linux-foundation.org> <m1wt1s6x2p.fsf@ebiederm.dsl.xmission.com> <45EFDD8C.3070702@garzik.org> <m1abyn7iin.fsf@ebiederm.dsl.xmission.com> <m1tzwv5wz9.fsf_-_@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tzwv5wz9.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> I have never have figured out how to get suspend/resume actually 
> working on any of my machines [...]

ouch! Are you interested in getting it work?

	Ingo
