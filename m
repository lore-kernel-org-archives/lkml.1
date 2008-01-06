Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbYAFVfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbYAFVfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 16:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYAFVfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 16:35:04 -0500
Received: from barikada.upol.cz ([158.194.242.200]:47235 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbYAFVfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 16:35:03 -0500
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jan 2008 16:35:02 EST
Date: Sun, 6 Jan 2008 22:41:36 +0100
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: translations (Re: Kbuild update)
Message-ID: <20080106214136.GA24008@flower.upol.cz>
References: <20080103213255.GA21811@uranus.ravnborg.org> <20080104132316.GA2485@hacking> <20080104143953.GA30536@uranus.ravnborg.org> <20080105054840.GB9976@does.not.exist> <20080106142606.GB2528@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080106142606.GB2528@hacking>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 10:26:06PM +0800, WANG Cong wrote:
> 
> >> It sort of stopped at one point due to missing integration in mainline.
> >> What I refer to is mostly the mconf.c bits, but I would also like to
> >> see what lkml says to a sample of .po files included in the kernel
> >> for a number of languages.
> >> 
> >> One criteria to get a .po file integrated could be at least 10% of the
> >> strings translated or similar.
> 
> Well, I think it's worthy. The translation effort will be valuable
> and much helpful for non-English-speaking peoples.
> 
> >
> >Besides the initial translation efforts a big problem would be to 
> >also find people who will regularly update the translations for
> >many years.
> >
> 
> Yes, that's really a problem. But I think the updates won't be
> too frequent, only update for stable release is enough.
> 
> If we can make this to be an offical project for Linux kernel, I
> think it won't be a big problem.

"I will use ...
http://images.google.cz/images?svnum=100&um=1&hl=cs&client=firefox-a&rls=org.mozilla%3Acs%3Aofficial&q=I+will+use+Google+before&btnG=Hledat+obr%C3%A1zky
... for making translations..."
http://www.google.com/translate?u=http%3A%2F%2Flxr.linux.no%2Flinux%2FDocumentation%2FHOWTO&langpair=en%7Czh-TW&hl=en&ie=UTF8
?

In case if people will help Google to have better quality of translation,
that will be better generally for much bigger number of *people*,
especially in China, isn't it?

Making any official world-domination/new-world-order projects with
Linux will not help IMHO. Very fast code flow and almost no up to date
documentation is still relevant and google search + email archives
are not going to be obsolete in the near future.

Also, future of the linux codebase with Chinese comments in C or in
ASM is kind of wired nightmare. Those, who cannot read actual source
code (i.e. C) will not go too far.

So, translation guys, maybe you will stop making noise and will start
to make e.g. less buggy Linux? Greg KH have much more stuff to care,
than some translations IMHO.

> Regards.
> 
> 
>  Cong
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______
