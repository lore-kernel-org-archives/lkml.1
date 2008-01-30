Return-Path: <linux-kernel-owner+w=401wt.eu-S1759267AbYA3XiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267AbYA3XiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 18:38:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbYA3Xhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 18:37:54 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:23987 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbYA3Xhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 18:37:53 -0500
Message-ID: <47A10A4F.3060203@msgid.tls.msk.ru>
Date: Thu, 31 Jan 2008 02:37:51 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: nigel@nigel.suspend2.net
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hibernate/suspend-to-disk: to turn power or not?
References: <47A0CD90.5080208@msgid.tls.msk.ru> <47A0EB65.1020505@nigel.suspend2.net>
In-Reply-To: <47A0EB65.1020505@nigel.suspend2.net>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham wrote:
[]
> That should be doable. How is your UPS connected? Presumably, with some
> modifications to the appropriate driver, we could send the commands when
> we're ready to shutdown. It would probably be useful whether or not your
> hibernating (if not, sending the commands could always be made an option).

You mean adding stuff to some KERNEL driver?  Like to a serial driver if
the UPS is connected to a COM-port??

I'm afraid either I don't understand what you're talking about here, or,
if I got you right, that YOU don't understand what you're talking about...

Come on, teaching kernel about various idiotic UPSes out there is more
than insane... ;)

/mjt
