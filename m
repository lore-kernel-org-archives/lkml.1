Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbYFYWpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbYFYWpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYFYWpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:45:09 -0400
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:50980 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362AbYFYWpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:45:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=gc+0DE+sFZSus0I4aUd06SorrbWZJjlRD3J6OVSH1OSFHYXHg5uiq1pHYGHKEWxh;
  h=Received:Message-ID:From:To:Cc:References:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <01ca01c8d715$1b127a60$0125a8c0@wednesday>
From: "jdow" <jdow@earthlink.net>
To: "Willy Tarreau" <w@1wt.eu>, "Matthew" <jackdachef@gmail.com>
Cc: <greg@kroah.com>, "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <e85b9d30806230602m10b5aa06m2f1c83e1a90a7dac@mail.gmail.com> <20080623132118.GC1369@1wt.eu>
Subject: Re: [ANNOUNCE] Position Statement on Linux Kernel Modules
Date: Wed, 25 Jun 2008 15:45:01 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-ELNK-Trace: bb89ecdb26a8f9f24d2b10475b57112035973a4c788463ce0e0139a688a2efcde34702530bcce501350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.183.103.112
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Willy Tarreau" <w@1wt.eu>
Sent: Monday, 2008, June 23 06:21


> On Mon, Jun 23, 2008 at 03:02:58PM +0200, Matthew wrote:
>> Hi Greg,
>> 
>> I largely agree to this statement,
>> 
>> there are however some downsides if you're preventing driver
>> manufacturers (e.g. nvidia, ...) from the possibility to offer their
>> customers proprietary drivers:
>> 
>> 1) One big and important point for me (and more and more future
>> linux-users) is powersaving features on GPUs like powermizer (by
>> nvidia) and powerplay (by AMD/ATI) or other hardware. I haven't seen
>> this working on newer graphics cards models with the opensource
>> drivers to the present day :(
> 
> I think that's one of the reasons of Greg's post.
> 
> (...)
>> if those companies can't use their own closed proprietary drivers
>> utilizing patented routines they are "forced" to use
> 
> You're wrong here. If they have patented routines, they don't need
> their drivers to be closed, since there routines are protected by
> patents. And even if they are not patented, not releasing the source
> will not prevent a competitor from disassembling the code anyway.
> So there's really no point in remaining closed. Some of them might
> have signed NDAs before using some technologies, but by this time,
> they should have sorted that our.

Willy, you make a bold assertion here. Your assertion would hold a
lot more weight if you defended it with some facts.

>> they might think over it and switch to another operating system ...
> 
> Do you know many products with closed Linux drivers which are not
> supported by at least one closed OS ? If they chose to support
> Linux, it's not for your pleasure, just because they know they will
> sell 5-10% more when a penguin is stuck on the box.

That is why there are the closed, and flakey, drivers for so many
products. Rather than make ideological assertions sit down and prove
your points. Address cases where there is an intellectual property
holder involved who has chosen Trade Secret rather than Patent as a
protection on their proprietary code. Show how they will stay in
business if they give away their code. Presume that their modules are
in clean enough shape that making money with a profitable service desk
is not going to fly.

> Willy

{^_^}   Jo
