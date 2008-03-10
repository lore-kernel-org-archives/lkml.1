Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYCJLY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYCJLY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 07:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYCJLYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 07:24:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:37745 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751349AbYCJLYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 07:24:17 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX19w/PgDCpFwUGEmgDvwLbOh17222dvN5QRHHGLTwj
	SunXUNRrzMuPh5
From: Jan-Simon =?iso-8859-1?q?M=F6ller?= <dl9pf@gmx.de>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Date: Mon, 10 Mar 2008 12:24:06 +0100
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       devzero@web.de, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       rick@vanrein.org
References: <182234194@web.de> <Pine.LNX.4.64.0803081210540.18589@twin.jikos.cz> <200803101112.45105.dl9pf@gmx.de>
In-Reply-To: <200803101112.45105.dl9pf@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803101224.07628.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 10 März 2008 11:14:48 schrieben Sie:
>
> Feel free to improve memmap documentation.
> 									Pavel


BUT ...
to do that, I would need to know already a bit of memmap ?!

This is a Chicken-egg-problem ! 

And I won't "waste" my time if i've a solution at hand already ?!

Lets do it like this: Show me what i need to know about the usage of memmap 
and i'll write some doc. 

Just shouting "write your own doc" is pointless, as I don't know this part of 
the kernel myself (yet).

Best regards
Jan-Simon
