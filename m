Return-Path: <linux-kernel-owner+w=401wt.eu-S1763416AbZFORBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763416AbZFORBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762194AbZFORBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:01:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54397 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761099AbZFORBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:01:07 -0400
Date: Mon, 15 Jun 2009 19:01:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090615170103.GE25040@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz> <20090610194852.GA28787@n2100.arm.linux.org.uk> <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com> <20090610213710.GA8472@elf.ucw.cz> <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com> <20090611082532.GE8592@elf.ucw.cz> <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com> <20090612150504.GA15084@elf.ucw.cz> <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Browsing -msm sources...

	{
		.name = "flash",
		.gpio = TROUT_GPIO_FLASH_EN,
		.max_timeout = 400,
	},


...in trout... Does dream really support flash?

	{
		.name = "spotlight",
		.gpio = TROUT_GPIO_SPOTLIGHT_EN,
	},

...what is spotlight? I wish dream had some way to produce light in
dark...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
