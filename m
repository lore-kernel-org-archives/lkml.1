Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbXJ3LWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbXJ3LWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXJ3LWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:22:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:33469 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbXJ3LWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:22:08 -0400
Date: Tue, 30 Oct 2007 12:22:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Hellwig <hch@infradead.org>, Jeff Lee <YY_Lee@issc.com.tw>
Cc: Daniel Hazelton <dhazelton@enter.net>, Ivo van Doorn <ivdoorn@gmail.com>,
       Dan Williams <dcbw@redhat.com>, Luis Correia <luis.f.correia@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, mwallis@serialmonkey.com
Subject: Licensing of IS89C35 WLAN USB driver [was Re: rt73usb: support for
	wireless in Kohjinsha subnotebook]
Message-ID: <20071030112221.GA17586@elf.ucw.cz>
References: <20071023090808.GB19758@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023090808.GB19758@infradead.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

You are listed as author of IS89C35 802.11bg WLAN USB Driver. That
driver has clear MODULE_LICENSE("GPL") tag, but not other notices.

Is it safe to assume whole sources are to be distributed under GPLv2?
(Or is it GPLv2 or later?)
								Pavel

> > there's nothing to suggest otherwise, and there's explicit:
> > 
> > #define DRIVER_AUTHOR                   "Jeff Lee<YY_Lee@issc.com.tw>"
> > #define DRIVER_DESC                             "IS89C35 802.11bg WLAN USB Driver"
> > MODULE_LICENSE("GPL");
> 
> So what about contacting the vendor and asking?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
