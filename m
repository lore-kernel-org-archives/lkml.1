Return-Path: <linux-kernel-owner+w=401wt.eu-S2992908AbXDYTCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992908AbXDYTCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992923AbXDYTCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:02:15 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:18984 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992908AbXDYTCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:02:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=tEjuzxIgighi88BqTrUJ0kaREnkTcnPqUkpwHofmsbyPWb9ZrCOpmlqb9PA7qx+7I6zZQU2Wml2JRs4AOQZQRCg0eVoYP+CpmkurKfIu9y0UPH4WSVRjqQw1d9iaYwOO/c44aPAEdzRy6ueYL76D1m5p5Uh4NSRbKG27VQRAK6k=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Adrian Bunk'" <bunk@stusta.de>
Cc: "'Pavel Machek'" <pavel@ucw.cz>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'Nigel Cunningham'" <nigel@nigel.suspend2.net>,
       "'Christian Hesse'" <mail@earthworm.de>,
       "'Nick Piggin'" <npiggin@suse.de>, "'Mike Galbraith'" <efault@gmx.de>,
       <linux-kernel@vger.kernel.org>, "'Con Kolivas'" <kernel@kolivas.org>,
       <suspend2-devel@lists.suspend2.net>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       "'Arjan van de Ven'" <arjan@infradead.org>
References: <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de> <20070425173405.GE17074@elf.ucw.cz> <20070425183934.GX3468@stusta.de> <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org>
Subject: RE: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Wed, 25 Apr 2007 12:02:01 -0700
Message-ID: <021401c7876c$36b640c0$a422c240$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
thread-index: AceHa0yd0MXZHrhBSYK9plMy/TZkBwAAEyBg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In STR, 3W is quite realistic. The CPU is off, all (or most - up to you)
> the devices are off, but the motherboard and memory is powered.
> 
> > And even 3W would still be a waste of energy.
> 
> .. but if the alternative is a feature that just isn't worth it, and
> likely to not only have its own bugs, but cause bugs elsewhere? (And
> yes,
> I believe STD is both of those. There's a reason it's called "STD". Go
> to google and type "STD" and press "I'm feeling lucky". Google is God).

Linus, the fact that you personally don't use S2D does not mean it's not
useful for other people. I've been using solely laptop for six years and
until recently (when my commute is now only two miles) I'd always used
hibernate when I go to or leave form work. And even now if I take my laptop
to somewhere farther away (like on a vacation) I need hibernation.

This is one area where Windows has been doing great for many years, and it's
not like Linux has not had a mature implementation for many years either. So
don't you think your comments are a bit odd at this point?

Hua


