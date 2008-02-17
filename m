Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbYBQUSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbYBQUSd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbYBQUSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:18:17 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:44575 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225AbYBQUSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:18:16 -0500
Date: Sun, 17 Feb 2008 21:44:47 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
Message-ID: <20080217194447.GD1403@cs181133002.pp.htv.fi>
References: <200802171025.30590.elendil@planet.nl> <20080217131611.GA1403@cs181133002.pp.htv.fi> <47B88A08.2070902@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47B88A08.2070902@imap.cc>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 08:24:56PM +0100, Tilman Schmidt wrote:
> Am 17.02.2008 14:16 schrieb Adrian Bunk:
>> The real problem is that the kernel seems to lack functionality you  
>> require for doing some work.
>>
>> Why does your work on the Debian Installer depend on VirtualBox and
>> can't be done with what the kernel already ships?
>
> No, that's not the real problem. Even if the kernel didn't lack
> any required functionality and it could all be done today without
> VirtualBox, pulling the rug from underneath it like that leaves
> all those who are currently relying on it without the ability to
> continue testing newer kernels until they find the time to redesign
> their working environment. Sticking to the removal schedule could
> have avoided that.

Frans said that he requires VirtualBox for his work on the Debian 
Installer.

If the kernel would offer everything Frans needs for his work on the 
Debian Installer he wouldn't have sent his email.

So let's fix the problem (kernel lacks functionality) and not the 
symptom (external module requires some export).

> HTH
> T.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

