Return-Path: <linux-kernel-owner+w=401wt.eu-S1761993AbXEZUC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761993AbXEZUC7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 16:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbXEZUCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 16:02:52 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:43577 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753841AbXEZUCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 16:02:51 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 May 2007 16:02:51 EDT
Message-ID: <46589133.9010608@lwfinger.net>
Date: Sat, 26 May 2007 14:57:39 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Uwe Bugla <uwe.bugla@gmx.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
References: <20070524195616.234280@gmx.net> <200705262003.17403.mb@bu3sch.de> <20070526111934.e4650b6f.akpm@linux-foundation.org> <200705262138.05501.uwe.bugla@gmx.de>
In-Reply-To: <200705262138.05501.uwe.bugla@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Bugla wrote:
> 
> OK, applied this one against 2.6.22-rc3, assuming a typo error by you, Andrew.
> 
> Result is: No change: non functionable b44 device!

Could you please send the following:

1. the output of lsmod from the non-functioning kernel

2. the output of dmesg from the non-functioning kernel

3. your .config used to create your non-functioning kernel.

Thanks,

Larry

