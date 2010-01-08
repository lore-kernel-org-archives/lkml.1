Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593Ab0AHQvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab0AHQvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 11:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384Ab0AHQvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 11:51:14 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:44071 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab0AHQvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 11:51:12 -0500
Message-ID: <a3581fd32d39b5e86aba9ded88bd5f46.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20100108163655.GA8328@elf.ucw.cz>
References: <201001071623.o07GNOB4022157@mustang.cs.nmsu.edu>
    <20100108083020.GB3696@core.coreip.homeip.net>
    <20100108163655.GA8328@elf.ucw.cz>
Date: Fri, 8 Jan 2010 09:50:33 -0700
Subject: Re: [PATCH] hid: Logitech G13 driver 0.0.3
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, felipe.balbi@nokia.com,
       jayakumar.lkml@gmail.com, linux-fbdev@vger.kernel.org,
       krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, jkosina@suse.cz
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
>
>> > +static DEVICE_ATTR(name, 0666, g13_name_show, g13_name_store);
>>
>> What this attribute is for?
>
> Actually, all the new files this added need to be documented.
> 									Pavel
>

Which is better? A hid-g13.txt file added to Documentation/ or comments in
the driver itself?

Thanks,

---

Rick


