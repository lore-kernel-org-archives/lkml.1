Return-Path: <linux-kernel-owner+w=401wt.eu-S1763705AbYBCLOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763705AbYBCLOc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 06:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYBCLOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:14:25 -0500
Received: from smtp7-g19.free.fr ([212.27.42.64]:52078 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbYBCLOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:14:24 -0500
X-Greylist: delayed 160150 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Feb 2008 06:14:23 EST
Message-ID: <2d7501c86656$4fe75380$f9b5a8c0@pii350>
From: "Gilles Espinasse" <g.esp@free.fr>
To: <greg@kroah.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only 
Date: Sun, 3 Feb 2008 12:17:06 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1914
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1914
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Again, I have asked for examples, and only received 2.  One (sound
> driver) is totally not needed at all, as the kernel provides that
> capability, and the other hasn't run in a modern distro for years.
>

I would consider you are a bit fast to state that :

a7n8x-e:~# gcc -dumpversion
3.3.6
a7n8x-e:~# cat /etc/issue
Debian GNU/Linux 4.0 \n \l

So unicorn driver could still be compiled on the current stable Debian that
has been released in April 2007.

Gilles

