Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab0CLBKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 20:10:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:53754 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab0CLBKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 20:10:32 -0500
Message-ID: <4B999467.4000501@kernel.org>
Date: Fri, 12 Mar 2010 10:09:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: tytso@mit.edu, Nikanth Karthikesan <knikanth@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Damian Lukowski <damian@tvk.rwth-aachen.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org>	 <472A4C80-30CE-4875-8073-F7E61659B6F0@mit.edu>	 <1268318374.2798.2.camel@mulgrave.site>	 <201003112035.26743.knikanth@suse.de>	 <20100311152551.GG1497@thunk.org> <87f94c371003110834t37235274yc641258ac5939c24@mail.gmail.com>
In-Reply-To: <87f94c371003110834t37235274yc641258ac5939c24@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Mar 2010 01:10:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/12/2010 01:34 AM, Greg Freemyer wrote:
> I do think the linux partitioners should provide a way to force a
> cylinder alignment.  Tejun, I would like to see your doc describe how
> to force a win2k compatible partition layout.

I suppose I can play with fdisk and list it as an example but if
anyone knows better/proper way to force certain partitions to legacy
alignment while leaving others properly aligned, I'll be happy to
include it.

Thanks.

-- 
tejun
