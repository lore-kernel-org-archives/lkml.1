Return-Path: <linux-kernel-owner+w=401wt.eu-S1761190AbYGQWRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761190AbYGQWRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757632AbYGQWRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:17:11 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:32958 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbYGQWRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:17:10 -0400
Date: Fri, 18 Jul 2008 01:16:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
Message-ID: <20080717221652.GF18326@cs181140183.pp.htv.fi>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com> <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org> <20080715204320.GJ24533@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080715204320.GJ24533@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another point that came into my mind:

How many scripts and programs out there parse the kernel version number,
know about the 2.6 prefix, and might need an update if it changes?

Not a big deal if a change would indicate a big change like with the old 
development model - but IMHO not worth it if there's no compelling 
reason why we have to change the numbering at all.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

