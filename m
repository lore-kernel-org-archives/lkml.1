Return-Path: <linux-kernel-owner+w=401wt.eu-S1762302AbXERLLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762302AbXERLLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 07:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbXERLLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 07:11:25 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:53855 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978AbXERLLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 07:11:24 -0400
Date: Fri, 18 May 2007 13:13:21 +0200
From: DervishD <lkml@dervishd.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
Subject: Re: usb-storage nice value
Message-ID: <20070518111321.GC4871@DervishD>
Mail-Followup-To: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org
References: <20070517100308.GA14667@DervishD> <464CB2B3.50506@s5r6.in-berlin.de> <20070518061512.GA32730@DervishD> <Pine.LNX.4.61.0705180829120.3231@yvahk01.tjqt.qr> <20070518082158.GA2307@DervishD> <Pine.LNX.4.61.0705181046260.3231@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0705181046260.3231@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Jan :)

 * Jan Engelhardt <jengelh@linux01.gwdg.de> dixit:
> 
> On May 18 2007 10:21, DervishD wrote:
> >
> >> Or try echo 10 >/proc/sys/kernel/dirty_ratio
> >
> >    Not in my proc :?? Perhaps /proc/sys/vm/dirty_ratio? Mine is 40,
> >which I think is too high.
> 
> Linus also thinks it is too high; I do not really care what it is set
> at, as it depends on the use case.

    I'll make some tests this weekend to find a good value for me,
starting at 10.

    Again, thanks :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
