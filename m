Return-Path: <linux-kernel-owner+w=401wt.eu-S1761475AbXEZTnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475AbXEZTnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 15:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbXEZTna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 15:43:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:33270 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753026AbXEZTn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 15:43:29 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX1+zkYIGijqzMdkcAugWgkCdGdmJNjX02etOjc91Ur
	XJmooF6+sFWOS9
From: Uwe Bugla <uwe.bugla@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 21:38:05 +0200
User-Agent: KMail/1.9.5
References: <20070524195616.234280@gmx.net> <200705262003.17403.mb@bu3sch.de> <20070526111934.e4650b6f.akpm@linux-foundation.org>
In-Reply-To: <20070526111934.e4650b6f.akpm@linux-foundation.org>
Cc: Uwe Bugla <uwe.bugla@gmx.de>, Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705262138.05501.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 26. Mai 2007 20:19 schrieben Sie:
> On Sat, 26 May 2007 20:03:17 +0200 Michael Buesch <mb@bu3sch.de> wrote:
> > Ok, please take git and get my development tree and try with that:
> >
> > git clone http://bu3sch.de/git/wireless-dev.git
> >
> > It's based on 2.6.22-rc1 and it works fine for me.
>
> Uwe has a slow connection, and getting the whole git thing
> set up would be quite a lump of effort.
>
> I prepared a diff of the above tree against 2.6.21-rc3.  It is at
> http://userweb.kernel.org/~akpm/git-mb.patch.gz

OK, applied this one against 2.6.22-rc3, assuming a typo error by you, Andrew.

Result is: No change: non functionable b44 device!

Thank you for your help!

Uwe
