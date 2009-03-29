Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbZC2Nqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbZC2Nqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZC2Nqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:46:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:33990 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbZC2Nqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:46:36 -0400
Message-ID: <49CF7BB6.2010609@petalogix.com>
Date: Sun, 29 Mar 2009 15:46:30 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Arnd Bergmann <arnd@arndb.de>, liqin.chen@sunplusct.com,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 5/13] score - New architecure port to SunplusCT S+CORE
 processor
References: <OFE9A5E3A2.37B73BA8-ON48257586.0008CFAC-48257586.00091B05@sunplusct.com> <200903272019.53689.arnd@arndb.de> <20090327202614.GA22054@uranus.ravnborg.org> <200903272153.05622.arnd@arndb.de> <20090327212251.GA22518@uranus.ravnborg.org>
In-Reply-To: <20090327212251.GA22518@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> Yes, I agree. Hopefully I'll manage to get my patches into
>> shape to post the generic versions in the next days so we can use
>> them on microblaze and score as well as all future versions.
>>     
>
> That would be gret.
> And I need to take a critical look at the patch from Remis Lima Baima -
> this would help those guys too.
>   
yes. I am open to it too. We can clean it and I'll test it and create
new toolchain for it too.
I hope we can reach generic solution which can be pattern for another archs.

Thanks,
Michal

P.S.: I am at LKML but please cc me (the best monstr@monstr.eu) for
every discuss around microblaze.

> 	Sam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

