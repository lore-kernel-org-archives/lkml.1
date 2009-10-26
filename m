Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZJZTxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZJZTxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbZJZTxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:53:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60071 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbZJZTxp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:53:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [Bug 11255] S3: no resume, not even a beep - LG R700
Date: Mon, 26 Oct 2009 20:55:24 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: bugzilla-daemon@bugzilla.kernel.org,
       Denys Rogovchenko <denisius.sion@gmail.com>,
       "Artem S.Tashkinov" <t.artem@mailcity.com>,
       ykzhao <yakui.zhao@intel.com>, len.brown@intel.com, gmaizel@gmail.com,
       linux-kernel@vger.kernel.org
References: <bug-11255-5003@http.bugzilla.kernel.org/> <8BDFD7B4-ABB5-45BD-BBC9-21C6AC4F48E9@ime.usp.br> <20091025000820.GA16225@ime.usp.br>
In-Reply-To: <20091025000820.GA16225@ime.usp.br>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910262055.24971.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 October 2009, Rogério Brito wrote:
> Hi, people.
> 
> First of all, to the bug reporters: please, let's get a bit more closer
> and try to join our forces.
> 
> Triaging the bug report, seeing what still happens with the current
> kernels etc. would all be helpful if we want to get our notebooks
> working.
> 
> OK, now to the problem itself.
> 
> After some time without internet connection (humpf), I am back online
> and I just did a git pull and a new kernel is being baked, soon to be
> served. :-)
> 
> I did collect quite a bunch of extra information (including newer blobs
> of dsdt, after the firmware upgrade from the firmware from MSI) and I
> will upload those in a moment.
> 
> I hope that this will help us to better decide what is the culprit and
> how we can better address this problem (perhaps asking MSI for some
> involvement?).
> 
> Anyway, just as an extra piece of information, my notebook is what MSI
> calls an MSI Aesthetic PR200 (well, at least after flashing it, that's
> what it reports :) and it didn't die with this upgrade).
> 
> Some extra pointers (a script, actually) of what I did to create a boot
> USB "disk" are outlined here: http://rb.doesntexist.org/diary/2009.xhtml

Thanks for being persistent.

Can you please attach the output of dmesg from 2.6.32-rc5 and the output
of lspci from the system to the bug entry?
