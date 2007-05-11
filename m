Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbXEKAiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbXEKAiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 20:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbXEKAh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 20:37:56 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35459 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbXEKAhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 20:37:55 -0400
Message-ID: <4643BA71.7050803@zytor.com>
Date: Thu, 10 May 2007 17:36:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Xavier Bestel <xavier.bestel@free.fr>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-raid@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Greaves <david@dgreaves.com>, Doug Ledford <dledford@redhat.com>
Subject: Re: Please revert 5b479c91da90eef605f851508744bfe8269591a0 (md partition
 rescan)
References: <17986.26930.952993.510918@notabene.brown>	 <alpine.LFD.0.98.0705091848370.4062@woody.linux-foundation.org>	 <Pine.LNX.4.61.0705101650340.24536@yvahk01.tjqt.qr>	 <1178809197.7699.4.camel@frg-rhel40-em64t-04> <a781481a0705100948x71279953ja4dc1903adda177@mail.gmail.com>
In-Reply-To: <a781481a0705100948x71279953ja4dc1903adda177@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 5/10/07, Xavier Bestel <xavier.bestel@free.fr> wrote:
>> On Thu, 2007-05-10 at 16:51 +0200, Jan Engelhardt wrote:
>> > >(But Andrew never saw your email, I suspect: "akpm@suse.de" is
>> > probably
>> > >some strange mixup of Andrew Morton and Andi Kleen in your mind ;)
>> >
>> > What do the letters kp stand for?
> 
> Heh ... I've always wanted to know that myself. It's funny, no one
> seems to have asked that on lkml during all these years (at least none
> that a Google search would throw up).
> 
>> "Keep Patching" ?
> 
> Unlikely. "akpm" seems to be a pre-Linux-kernel nick.

http://en.wikipedia.org/wiki/Andrew_Morton_%28computer_programmer%29

	-hpa

