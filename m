Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbZFAKll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbZFAKll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbZFAKle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:41:34 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:42683 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbZFAKld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:41:33 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: ttyACM0: when the device dies, 2.6.30-rc7 dies, too, strange echo (regression)
Date: Mon, 1 Jun 2009 12:42:06 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20090601101421.GA1914@elf.ucw.cz> <20090601102546.GA2288@elf.ucw.cz>
In-Reply-To: <20090601102546.GA2288@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906011242.06244.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 1. Juni 2009 12:25:46 schrieb Pavel Machek:
> Hi!
>
> > I believe this worked before; on 2.6.30-rc7, when ttyACM0 dies
> > (openmoko in bootloader powers off) the notebook I'm running minicom
> > on dies, too :-(. For the first time, I did not catch any messages,
> > I'll retry the test on console.
>
> Nothing useful on the console...
>
> And it gets worse: with 2.6.30-rc7, I only get echo on character N
> when I type character N=1. Which is extremely confusing and basically
> makes it unusable for interactive work. This definitely worked
> before... but it was quite long ago.

Do you have any reason to assume these bugs are related? If not,
please keep them separate.

Can you please be more specific what exactly fails?

	Regards
		Oliver

