Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbXIURj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbXIURj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbXIURjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:39:23 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:6139 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750919AbXIURjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:39:22 -0400
Message-ID: <46F401D6.6060609@cfl.rr.com>
Date: Fri, 21 Sep 2007 13:39:34 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: David Newall <david@davidnewall.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Bill Davidsen <davidsen@tmr.com>,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <46F0CD96.9030807@prepere.com>	<20070919104018.3a6bcfb1@the-village.bc.nu>	<46F16A0A.3070402@tmr.com> <20070919194559.36015307@the-village.bc.nu> <46F1A196.8060108@davidnewall.com>
In-Reply-To: <46F1A196.8060108@davidnewall.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2007 17:39:32.0967 (UTC) FILETIME=[5EC52F70:01C7FC76]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15438.000
X-TM-AS-Result: No--12.646100-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> * In particular, the superuser can escape from a =91chroot jail=92 by d=
> oing=20
> =91mkdir foo; chroot foo; cd ..=92.

No, he can not.

