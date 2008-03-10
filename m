Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYCJRse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYCJRse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYCJRs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:48:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:57416 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751254AbYCJRsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:48:25 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX1846NtD/Vs4CKKXe1iHYmcZm9tHNxzzImn0MjIs3r
	O/4XnQfWg6L2CW
From: Jan-Simon =?iso-8859-1?q?M=F6ller?= <dl9pf@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Date: Mon, 10 Mar 2008 18:48:12 +0100
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, devzero@web.de,
       linux-kernel@vger.kernel.org, rick@vanrein.org
References: <182234194@web.de> <200803101523.03620.dl9pf@gmx.de> <47D56DD3.8060108@zytor.com>
In-Reply-To: <47D56DD3.8060108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803101848.13085.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 10 März 2008 18:20:19 schrieb H. Peter Anvin:
> Jan-Simon Möller wrote:
> > badram=0x18690000,0xffff0000
> > (which means a whole from 0x18690000 to 0x1869ffff )
>
> memmap=0x18690000$64K
>
> 	or
>
> memmap=0x18690000$0x10000
>
> 	-hpa

Thanks a lot ! 

I'll reply with a patch for the Documentation and add an example.

Best regards,
Jan-Simon
