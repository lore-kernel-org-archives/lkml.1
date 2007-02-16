Return-Path: <linux-kernel-owner+w=401wt.eu-S1423147AbXBPE0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423147AbXBPE0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 23:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161751AbXBPE0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 23:26:35 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:42261 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161750AbXBPE0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 23:26:34 -0500
Message-ID: <45D5325A.2040502@gmail.com>
Date: Fri, 16 Feb 2007 05:26:02 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sergei Organov <osv@javad.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       =?ISO-8859-15?Q?=22J=2EA=2E_Magall=C3=C3=C3=C3=C3=C2=B3n=22?= 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org> <87abznsdyo.fsf@javad.com> <Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org> <874pprr5nn.fsf@javad.com> <Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org> <87ps8end9b.fsf@javad.com> <84144f020702131026q2af1afd6vbcd2708d7b7b9907@mail.gmail.com> <87bqjxooog.fsf@javad.com> <84144f020702131143r767aa40blb97a39b40bee73b8@mail.gmail.com> <87fy99n6mf.fsf@javad.com> <Pine.LNX.4.64.0702131513050.3604@woody.linux-foundation.org> <87hctnlfqz.fsf@javad.com> <Pine.LNX.4.64.0702150736360.20368@woody.linux-foundation.org> <87k5yjjlrj.fsf@javad.com> <Pine.LNX.4.64.0702151059090.20368@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702151059090.20368@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2007 08:02 PM, Linus Torvalds wrote:

> Think of it this way: in science, a theory is proven to be bad by a
> single undeniable fact just showing that it's wrong.
> 
> The same is largely true of a warning. If the warning sometimes
> happens for code that is perfectly fine, the warning is bad.

Slight difference; if a compulsory warning sometimes happens for code 
that is perfectly fine, the warning is bad. I do want to be _able_ to 
get as many warnings as a compiler can muster though.

Given char's special nature, shouldn't the conclusion of this thread 
have long been simply that gcc needs -Wno-char-pointer-sign? (with 
whatever default, as far as I'm concerned).

Rene.
