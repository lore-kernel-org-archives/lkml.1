Return-Path: <linux-kernel-owner+w=401wt.eu-S1751010AbXD1OHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010AbXD1OHF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 10:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXD1OHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 10:07:05 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:44582 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbXD1OHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 10:07:03 -0400
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=booyaka.com;
  b=Zy8oLdTGJfgql6/qX0I038yfmtW4tmGhrlYt05hb3zIbS5HUnzPcS3EdQLd85yXz4UzlLZxyZUnXJpCsWXOaEDcVj6l6nT/biSbY8HoqVtRNhR3LebYnYA43mtTtIznyOUmhEGHnyzXH6AZVtsDru1lPcnJBoSTcr0qYMH6e4Ld4PqcUJxS1WktgZJI6M/oQYOLx/ZOnHNb83mWeojIdxiTstQeHqyEmX3Bem6VFzT0HvKca89rhVuQ2rQ9ocGnWDEB+xYzFSSiACn5D/tCsXrqGhc0111v8tw1lu8pFHHlPwt552g9Vecj7aFqFwZ0+cviak0OQQgaAAG9mVfuZvQ==  ;
Date: Sat, 28 Apr 2007 08:07:02 -0600 (MDT)
From: Paul Walmsley <paul@booyaka.com>
To: Vincent ETIENNE <ve@vetienne.net>
cc: Jiri Kosina <jkosina@suse.cz>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: USB HID bug (was [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1)
In-Reply-To: <200704280921.19265.ve@vetienne.net>
Message-ID: <Pine.LNX.4.64.0704280804070.21519@utopia.booyaka.com>
References: <200704262058.33087.ve@vetienne.net> <20070427211836.GC5917@kroah.com>
 <Pine.LNX.4.64.0704280024170.7370@jikos.suse.cz> <200704280921.19265.ve@vetienne.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Vincent ETIENNE wrote:

> With your patch it seems like idVendor passed is 0. You could see it there ;
>
> http://mail1.vetienne.net/linux/dmesg.2.6.21-rc7-mm2+patch-usbhid
>
> I could confirm that the keyboard is working ( yesterday i was just behind the
> box due to test on the network ). But i don't remember if the keyboard is USB
> or PS2 (i only have ssh access to the box for the next 3/4 days)

It seems that OpenBSD users are reporting similar problems:

http://article.gmane.org/gmane.os.openbsd.misc/122526

http://www.mail-archive.com/misc@openbsd.org/msg38200.html


- Paul
