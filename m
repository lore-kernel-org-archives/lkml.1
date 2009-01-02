Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbZABTa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbZABTa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbZABTaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:30:16 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:54244 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbZABTaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:30:15 -0500
Date: Fri, 2 Jan 2009 20:31:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Valdis.Kletnieks@vt.edu, Bryan Donlan <bdonlan@gmail.com>,
       Ingo Brueckl <ib@wupperonline.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Replace CONFIG_EMBEDDED [Was: x86 (Linux Tiny): configure out support for some processor]
Message-ID: <20090102193152.GA6815@uranus.ravnborg.org>
References: <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com> <20090102093801.GD1975@elte.hu> <3f9a31f40901020710h508bbfbch3d7ccd6f4898ea03@mail.gmail.com> <11444.1230910752@turing-police.cc.vt.edu> <3f9a31f40901020813t136ad2ceif1092f312866a0ce@mail.gmail.com> <20090102162120.GG1180@elte.hu> <3f9a31f40901020838v333a968dv937a717e031743eb@mail.gmail.com> <20090102173435.GE6759@elte.hu> <20090102181345.GB5905@uranus.ravnborg.org> <495E64D8.1030200@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495E64D8.1030200@tmr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >CONFIG_EXPERT
> >
> >For other stuff that no 'ordinary' user will need to change
> >but the expert may find it usefull.
> >
> >Everything we hide under EMBEDDED today would fit in the
> >categories above.
> >
> >
> Don't forget "CONFIG_EXPERT_STACK_SIZE" for 4k x86 stacks.
I am not sure I follow you.
But changing the default stack size is a good candidate to hide
between CONFIG_EXPERT.

	Sam
