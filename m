Return-Path: <linux-kernel-owner+w=401wt.eu-S1423092AbXDXUvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423092AbXDXUvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423096AbXDXUvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:51:37 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:16339 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423094AbXDXUvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:51:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=Di6pSHpDU1+MZ5j6xkj5cd7I9Bf8ha7FLtJv4mjTR4NFf1KC2MDEnX9p6dsstlWS9DgTRtuVbD35jvzVrGIY7zO0jsv8qtvp0Y1ezWhNTyMoAnqycbl4DlsHb7T9P8kvv8sVfSQFU4dcw6hJu8KB0HECqcuOYNJCDchMTWPyHvk=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Pavel Machek'" <pavel@ucw.cz>
Cc: "'Ingo Molnar'" <mingo@elte.hu>,
       "'Nigel Cunningham'" <nigel@nigel.suspend2.net>,
       "'Christian Hesse'" <mail@earthworm.de>,
       "'Nick Piggin'" <npiggin@suse.de>, "'Mike Galbraith'" <efault@gmx.de>,
       <linux-kernel@vger.kernel.org>, "'Con Kolivas'" <kernel@kolivas.org>,
       <suspend2-devel@lists.suspend2.net>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       "'Arjan van de Ven'" <arjan@infradead.org>
References: <20070413202100.GA9957@elte.hu> <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
Subject: RE: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Tue, 24 Apr 2007 13:51:26 -0700
Message-ID: <01c901c786b2$554563a0$ffd02ae0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
thread-index: AceGsXTIOHXcMBDxQRSA34RM2fK/BgAAJytg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This whole notion that "kernel lines of code" is somehow different is a
> stupid and idiotic _disease_ that is spread by microkernel people and
> people who have been brainwashed by them.

I think a lot of people are tired of this argument, but I am glad you speak
up (as you did last year wrt s2ram).

> The only thing that matters is the end result

Amen to that. The end result is not just code size, but quality and whether
it actually *works reliably*.

Cheers,

Hua

