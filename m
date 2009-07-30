Return-Path: <linux-kernel-owner+w=401wt.eu-S1751552AbZG3PfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbZG3PfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZG3PfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:35:18 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:62092 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbZG3PfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:35:17 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] kdesu broken
Date: Thu, 30 Jul 2009 11:35:03 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4; KDE/4.2.4; i686; ; )
Cc: Frans Pop <elendil@planet.nl>, alan@lxorguk.ukuu.org.uk,
       torvalds@linux-foundation.org, hirofumi@mail.parknet.co.jp,
       aneesh.kumar@linux.vnet.ibm.com, rjw@sisk.pl, ray-lk@madrabbit.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       stern@rowland.harvard.edu
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk>
 <200907291519.19567.gene.heskett@verizon.net>
 <28783.1248957815@turing-police.cc.vt.edu>
In-reply-to: <28783.1248957815@turing-police.cc.vt.edu>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-15
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200907301135.03509.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 July 2009, Valdis.Kletnieks@vt.edu wrote:
>On Wed, 29 Jul 2009 15:19:19 EDT, Gene Heskett said:
>> Whenever I let rpm get access to my grub.conf, I always have to go back in
>> with vim & fix the stanza numbers I keep track of the boots with.  Grub
>> doesn't really care, but I do. :)  rpm should be so neat...
>
>Just to be accurate - this isn't rpm's fault, it's a program called
> 'grubby'.
>
>I understand the reasoning - if you just installed a new kernel, you
> probably want it to be the one started at next boot.  But it would be nice
> if grubby had a configure option for that in /etc/sysconfig/grubby or
> someplace...

Humm, kewl.  And the src's for grubby are where?  Hopefully in C so thois old 
fart can grok...

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

The best laid plans of mice and men are held up in the legal department.

