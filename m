Return-Path: <linux-kernel-owner+w=401wt.eu-S1763789AbXINOzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763789AbXINOzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXINOzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:55:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39467 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXINOzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:55:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46EAA08F.30703@s5r6.in-berlin.de>
Date: Fri, 14 Sep 2007 16:54:07 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <1189371621.3526.28.camel@localhost.localdomain> <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org> <20070912224655.GC3563@stusta.de>
In-Reply-To: <20070912224655.GC3563@stusta.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Sep 09, 2007 at 05:11:44PM -0400, Jeff Garzik wrote:
>> Let's step back a moment and consider the actual scale and impact of the 
>> problem at hand.
>>
>> The vast majority of users are consumers of pre-compiled kernels, built by 
>> People With Clue(tm), who figured this stuff out as soon as it was 
>> introduced.
[...]
> In my experience, the vast majority of kconfig users are not the few 
> people working on distribution kernels, most of the kconfig userbase 
> could be better described by the use case "sysadmin who knows about the 
> hardware in his machine and which filesystems he uses".

The patch which is discussed here is specifically targeted towards users
who are convinced that they can migrate to different drivers without
reading Kconfig help texts.
-- 
Stefan Richter
-=====-=-=== =--= -===-
http://arcgraph.de/sr/
