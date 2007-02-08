Return-Path: <linux-kernel-owner+w=401wt.eu-S1422865AbXBHLed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422865AbXBHLed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 06:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422897AbXBHLed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 06:34:33 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:52497 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422865AbXBHLec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 06:34:32 -0500
Date: Thu, 8 Feb 2007 12:29:07 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kai Germaschewski <kai@germaschewski.name>
Subject: Re: + search-a-little-harder-for-mkimage.patch
In-Reply-To: <20070208064347.GP22699@flower.upol.cz>
Message-ID: <Pine.LNX.4.61.0702081227560.1364@yvahk01.tjqt.qr>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0702071846180.14457@scrub.home> <20070207220435.GC22699@flower.upol.cz>
 <Pine.LNX.4.64.0702080029030.14457@scrub.home>
 <Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org>
 <20070207203047.51a95ad0.akpm@linux-foundation.org> <20070208052439.GL22699@flower.upol.cz>
 <20070207211921.1f0220a4.akpm@linux-foundation.org> <20070208055832.GN22699@flower.upol.cz>
 <8bd0f97a0702072158r36046dd7w64a8c7b5da1a5f9a@mail.gmail.com>
 <20070208064347.GP22699@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 8 2007 07:43, Oleg Verych wrote:
>> >>
>> >> > If that matter, `type -path' is bashizm (BloAted SHell), and "blackbox"
>> >> > with "dash" (very good `sh' equivalents) will fail.
>> >>
>> >> Does the kernel presently build with that shell?
>> >
>> >build - yes, with dash being `$(shell)'. All scripts with `#!/bin/bash'
>> >of course use bash, example is gen_initramfs_list.sh.
>> 
>
>Heh, did i say POSIX? I said bloated shell, from man bash:
>
>BUGS
>       It's too big and too slow.

Like it or lump it. Improve it, or write your own bash-compliant sh. :)
