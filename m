Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbYIZFaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbYIZFaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 01:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbYIZF3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 01:29:53 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:59322 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818AbYIZF3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 01:29:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAJQO3Eg7p+/x/2dsb2JhbACBXrkygWQ
X-IronPort-AV: E=Sophos;i="4.33,310,1220193000"; 
   d="scan'208";a="200142209"
Message-ID: <48DC734B.8070805@call-direct.com.au>
Date: Fri, 26 Sep 2008 15:29:47 +1000
From: Iwo Mergler <iwo@call-direct.com.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080302)
MIME-Version: 1.0
To: Paul Eddington <eddingtonpaul@googlemail.com>
CC: linux-kernel@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Re: Bug in rt2x00 rt73usb driver in latest git kernel
References: <762793250809241102n61ea8f00kca8138bc3c8df2e6@mail.gmail.com>
In-Reply-To: <762793250809241102n61ea8f00kca8138bc3c8df2e6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Eddington wrote:
> Hi,
> 
> While running the latest git kernel (linus' tree) and using a usb wifi
> card, I got this error in dmesg:;
> 
> phy2 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry
> in the non-full queue 2.
> Please file bug report to http://rt2x00.serialmonkey.com.
> 
> This is not reproducible easily, but it has occurred on two occasions
> both while connected to a WEP encrypted AP with a 40-bit key and
> performing many file samba transfers at full speed 54mbits.
> 
> I tried to report the bug there but was unable to register and edit
> the bug reports wiki page.
> If there is any more information or help required to debug this,
> please let me know.
> 
> Regards,
> Paul
> --

Hi Paul,

the rt2x00 drivers are currently a very fast moving target. You may want
to experiment with the rt2x00 kernel tree instead - it gets the patches
(and the bugs) earlier. ;-)

http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=summary

I added the rt2x00 mailing list to CC.

Kind regards,

Iwo

