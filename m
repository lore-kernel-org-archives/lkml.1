Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYEWFMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYEWFMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 01:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYEWFMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 01:12:21 -0400
Received: from mail.aknet.ru ([78.158.192.26]:55482 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbYEWFMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 01:12:21 -0400
Message-ID: <4836522C.6000409@aknet.ru>
Date: Fri, 23 May 2008 09:12:12 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: dbrownell@users.sourceforge.net
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] provide rtc_cmos platform device
References: <483317B4.7060601@aknet.ru> <20080521153223.e989cb88.akpm@linux-foundation.org>
In-Reply-To: <20080521153223.e989cb88.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

David Brownell wrote:
> Sure you can help; that's why I sent the compiler
> messages telling what went wrong. You were
> referencing symbols that are not defined on
> non-pnp systems.
OK, I actually realized that after
sending the message. :)
The new patch should be better for
that regard, but your mail address
rejects:
---
A message that you sent could not be delivered to one or more of its
recipients. This is a permanent error. The following address(es) failed:

  david-b@pacbell.net
    SMTP error from remote mail server after MAIL FROM:<stsp@aknet.ru>:
    host pbimail7.prodigy.net [207.115.37.22]: 553 5.3.0
nlpi092,DNSBL:521< 78.158.192.26
>_is_blocked.__For_information_see_http://worldnet.att.net/general-info/bls_info/block_inquiry.html
---

> I understand Russell King has been sitting on a
> similar patch (for the generic bits, not the x86
> specific parts) for some time. Maybe you can get
> his patch, which will surely work on ARM.
Because you haven't CCd me, I
already sent a new one.
