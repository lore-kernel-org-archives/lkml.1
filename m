Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab0CCLMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:12:35 -0500
Received: from mbox2.netikka.net ([213.250.81.203]:49308 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab0CCLMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:12:33 -0500
Message-ID: <4B8E441F.5090701@mandriva.org>
Date: Wed, 03 Mar 2010 13:12:31 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100302 Mandriva/3.0.3-1mdv2010.1 (2010.1) Thunderbird/3.0.3
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>
CC: Linus Torvalds <torvalds@linux-foundation.org>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm request 2
References: <alpine.DEB.2.00.1003012345440.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003021451130.3616@localhost.localdomain> <alpine.DEB.2.00.1003022300320.4099@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.1003022300320.4099@skynet.skynet.ie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

03.03.2010 01:02, Dave Airlie skrev:
>>> x86 after PPC (I think I just validated Ingo).
>>
>> Why is VGA_SWITCHEROO enabled by default?
>
> because it does nothing on anything except the laptops in question and on
> those it does nothing except add a control file in debugfs?
>
> So how am I supposed to indicate to distro vendors that something should
> be turned on? If you think that distro kernel maintainers really
> understand every config option that goes past, I've got a bridge.
>

Yep. If the help-text for a new config option is well written, a kernel 
maintainer will have no problem deciding what to do.
(the help text for the config in question is wery well written, thanks
  to whoever wrote that)

And this specific option/feature is already requested by endusers, so no
maintainer will be able to "miss it" :-)

--
Thomas
