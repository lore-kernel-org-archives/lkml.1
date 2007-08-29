Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbXH2O1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbXH2O1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 10:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXH2O1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 10:27:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:19693 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbXH2O1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 10:27:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HOx89hniLVPm6JJwrOssjAsPvWCV9c8aZnxCC1FwGtNBLhWtsuCYngRA718DmasfDDoHiVVWGwBId3KitEkY24jUSbXOLld8xtNN/8YpJXZPrPiTXdOVl9aUbV1jO5w/qndMqagZvhopGlCZbDVE0NzkkaPNjJfcouGlPYSRdVc=
Message-ID: <6bffcb0e0708290727s23dd25d6t9452f90f2efa5c4a@mail.gmail.com>
Date: Wed, 29 Aug 2007 16:27:14 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: 2.6.23-rc4, now on third reboot
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200708290159.14456.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708290159.14456.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gene,

On 29/08/2007, Gene Heskett <gene.heskett@gmail.com> wrote:
> Greetings;
>
> About 8 hours uptime, firefox/kmail & a bunch of tails running on logs, an
> amanda session running in the background, reading groklaw with FF.  click,
> blank screen, reboot, nothing in the logs.
>
> 10 minutes later, everything locks up about 2 minutes after I start an amflush
> session to cleanup after the last crash.  The log, according to the tail I
> had running on it at the time of the freeze, has this, and it just crashed &
> self rebooted again, so I'm back on -rc3:
> ==========
> Aug 29 01:06:52 coyote kernel: hdd: dma_timer_expiry: dma status == 0x61
> ==========
>
> The 2nd time I go into bios and reset some things to default.
>
> The third time I rebooted to 2.6.23-rc3, which had been running stable for 15
> days worth of uptime.
>
> On the 2nd crash, the kpanel clock was frozen, no response from any key
> combo.
>
> Third time, just a click and a black screen as it posted again.
>
> Has anyone else encountered this or do I have hardware on the way out?
>
> Now, lets see if I can cleanup the spillage from amanda.  And it reset again.
>
> This time I turned the VCore 1 voltage down about .05 volts in the bios, to
> around 1.62 volts.  Just for effects, like a little rum in the morning
> coffee.  Its an athlon XP-2800 that has always run a little warm, showing
> 145F now, but has hit 161F a couple times with no ill effects that I know of.

Please try to capture this bug. Net or serial console would be useful.

Chapter 3 "Collecting kernel messages"
http://www.stardust.webpages.pl/files/handbook/handbook-en-0.3-rc1.pdf

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
