Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbYAINdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbYAINdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 08:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYAINdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 08:33:14 -0500
Received: from barikada.upol.cz ([158.194.242.200]:33155 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYAINdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 08:33:12 -0500
Date: Wed, 9 Jan 2008 14:50:24 +0100
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: translations (Re: Kbuild update)
Message-ID: <20080109135024.GD24008@flower.upol.cz>
References: <20080103213255.GA21811@uranus.ravnborg.org> <20080104132316.GA2485@hacking> <20080104143953.GA30536@uranus.ravnborg.org> <20080105054840.GB9976@does.not.exist> <20080106142606.GB2528@hacking> <20080106214136.GA24008@flower.upol.cz> <20080109022208.GD2480@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109022208.GD2480@hacking>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@ Wed, Jan 09, 2008 at 10:22:08AM +0800, WANG Cong wrote:
> 
> >"I will use ...
> >http://images.google.cz/images?svnum=100&um=1&hl=cs&client=firefox-a&rls=org.mozilla%3Acs%3Aofficial&q=I+will+use+Google+before&btnG=Hledat+obr%C3%A1zky
> >... for making translations..."
> >http://www.google.com/translate?u=http%3A%2F%2Flxr.linux.no%2Flinux%2FDocumentation%2FHOWTO&langpair=en%7Czh-TW&hl=en&ie=UTF8
> >?
> >
> >In case if people will help Google to have better quality of translation,
> >that will be better generally for much bigger number of *people*,
> >especially in China, isn't it?
> 
> Perhaps yes.
> 
> But at least now, that kind of translation still sucks. It can
> satisfy me.
> 
> >
> >Making any official world-domination/new-world-order projects with
> >Linux will not help IMHO. Very fast code flow and almost no up to date
> >documentation is still relevant and google search + email archives
> >are not going to be obsolete in the near future.
> >
> >Also, future of the linux codebase with Chinese comments in C or in
> >ASM is kind of wired nightmare. Those, who cannot read actual source
> >code (i.e. C) will not go too far.
> >
> >So, translation guys, maybe you will stop making noise and will start
> >to make e.g. less buggy Linux? Greg KH have much more stuff to care,
> >than some translations IMHO.
> 
> I never say to translate C comments. What we want to translate is the
> strings in Kconfig.

ftp://flower.upol.cz/upload/Configure.help

OK, please, take a look at stuff, Korean guys did 5-6 years ago. One
particular ARM port (S3C2410X) along with an ARM bootloader (vivi) was
done. Yet for some reason official Linux port has another developers, and,
it seems, it was done some time (~1-2 years) later.

> I abosutely agree that we should focus on the exsiting bugs of Linux,
> but like Greg's inclusion of some kernel doc translations, this kind
> of work is really helpful to attract some kernel newbies from none
> English-speaking countries. Even we can't make offical efforts,
> the civil work, like TLKTP, is still worthy.
...

> Believe me, I am leading a local LUG in my college and I found that one
> _big_ reason that why the newbies are afraid of Linux kernel is
> English, instead of the C tricks or low-level programming.

IMHO, there is so much stuff done, that any brilliant C or whatever-asm
coder *have* to study at least something of it. And, in order to do a
valuable contribution, one must know the work-flow, people *and* English.
This is usually done by reading mailing list *and* archives for quite
some time. This takes time, this takes effort, but this also have huge
impact on intelligence and culture of the `coders'.

Do you ever have a question about why History exists and is studied on
all levels of education? Same with programming. Without
history-via-English, one have no strong roots, thus base for grow and
flower.

OTOH, Internet has so much noise and crap all over the place, that
information is very hard to find. It takes much time to sort and see it.
Yet, providing noise generating, like in-tree translations, seems, is a
very easy way around (not taking maintaining in account).
____
