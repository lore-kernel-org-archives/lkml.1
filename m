Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbXCHU1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbXCHU1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933295AbXCHU1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:27:32 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55862 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294AbXCHU1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:27:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
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
References: <45ED8A12.5040803@intel.com>
	<m1ejo1elj6.fsf@ebiederm.dsl.xmission.com>
	<45EEE8CF.1060803@intel.com> <45EEEC2C.5090609@intel.com>
	<m1649cdfas.fsf@ebiederm.dsl.xmission.com>
	<20070307185317.5601d452.akpm@linux-foundation.org>
	<m1wt1s6x2p.fsf@ebiederm.dsl.xmission.com>
	<45EFDD8C.3070702@garzik.org>
	<m1abyn7iin.fsf@ebiederm.dsl.xmission.com>
	<m1tzwv5wz9.fsf_-_@ebiederm.dsl.xmission.com>
	<20070308200809.GA10088@elte.hu>
Date: Thu, 08 Mar 2007 13:26:12 -0700
In-Reply-To: <20070308200809.GA10088@elte.hu> (Ingo Molnar's message of "Thu,
	8 Mar 2007 21:08:09 +0100")
Message-ID: <m1ejnz5vob.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> I have never have figured out how to get suspend/resume actually 
>> working on any of my machines [...]
>
> ouch! Are you interested in getting it work?

I haven't even seriously tried. I don't yet have a laptop and I like
staying logged.  The first time I rolled the jiffie counter it was a
happened after I had realized that if I kept my machine up for another
couple of months my jiffie counter would roll and I said why not  So
basically suspend hasn't been a feature I'm been interested in using.
I get more annoyed at my UPS failing..

I will probably get around to figuring out the whole suspend/resume
thing one of these days and it will probably take me a day or two.
But that doesn't result in bug fixes being delivered in a timely manner.

Eric
