Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbXD0WiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbXD0WiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbXD0WiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:38:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:54419 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512AbXD0WiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=iKqkGxukAt2hPwA6JBYS9i7TG1m7BdBTdOKgpZplsMYy4qR1l+OT7BwG1V8m+3p3ZfRMMYqhxfbaldYtc8ZPkWp+z0iyO/iwcbhL6gLXvlRNCvaBLIvYBcZZRRV6smN2CxTygpp0gRpSAF6uWHjy0xii/qaZdFM9NSyqooi0w7w=
Message-ID: <6bffcb0e0704271538v435bfd45u7e06a7f5f5e9a8b@mail.gmail.com>
Date: Sat, 28 Apr 2007 00:38:07 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc7: known regressions
Cc: stable@kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Riccardo Ricci" <rricci@nuovanetmore.it>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       linux-acpi@vger.kernel.org, "Len Brown" <len.brown@intel.com>,
       "David Brownell" <david-b@pacbell.net>, "Jeff Mahoney" <jeffm@suse.com>,
       reiserfs-dev@namesys.com
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of known regressions reported after 2.6.21 release.

Feel free to add new regressions/remove fixed etc.
http://lkr.wikidot.com/list

Subject : 2.6.21 don't boot, it stops after ACPI: PCI Interrupt Link
[LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 14 15).
References : http://lkml.org/lkml/2007/4/27/400
Submitter : Riccardo Ricci <rricci@nuovanetmore.it>
Status : unknown

Subject : ACPI interpreter errors
References : http://lkml.org/lkml/2007/4/27/206
Submitter : Udo A. Steinberg <us15@os.inf.tu-dresden.de>
Status : unknown

Subject : reiserfs — circular locking
References : http://lkml.org/lkml/2007/4/26/648
Submitter : David Brownell <david-b@pacbell.net>
Handled-By : Jeff Mahoney <jeffm@suse.com>
Status : patch available http://lkml.org/lkml/2007/4/27/332

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
