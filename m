Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbXKLLIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbXKLLIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 06:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbXKLLHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 06:07:51 -0500
Received: from relay.lloydadriatico.it ([194.185.101.20]:28857 "EHLO
	relay.lloydadriatico.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014AbXKLLHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 06:07:50 -0500
X-Greylist: delayed 619 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Nov 2007 06:07:49 EST
X-IronPort-AV: E=Sophos;i="4.21,404,1188770400"; 
   d="scan'208";a="5987646"
Message-ID: <2C8305E0BE090E47A2BAD52A48AC911D17BCEB92@exchange1.lloyd.com>
From: SANGOI DINO LEONARDO <dino.leonardo.sangoi@allianz.it>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       SANGOI DINO LEONARDO <dino.leonardo.sangoi@allianz.it>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Brown, Len" <len.brown@intel.com>,
       linux-acpi@vger.kernel.org
Subject: RE: 2.6.24-rc1 and 2.6.24.rc2 hangs while running udev on my lapt
	op
Date: Mon, 12 Nov 2007 11:57:19 +0100
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2653.19)
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 10, 2007 1:53 AM, Venki Pallipadi
[mailto:venkatesh.pallipadi@intel.com] wrote:
> 
> Dino,
> 
> Can you try the patch below over rc2 and see whether it fixes 
> the problem.
> Looking at the code, it should fix the problem. If it does 
> not, can you send me the output of acpidump from your system. 
> That will help to look further into this. You can get 
> acpidump from latest pmtools package here.
> www.kernel.org/pub/linux/kernel/people/lenb/acpi/utils/
> 
Venki,

Thanks, but sadly your patch does not fix the problem.

I have created a new bugzilla bug in the kernel bugtraker
(http://bugzilla.kernel.org/show_bug.cgi?id=9355), where you can find the
acpi dump and config.

Ask me if I can try something else.

Thanks,

Dino
