Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbYAICWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbYAICWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYAICWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:22:33 -0500
Received: from po-out-1718.google.com ([72.14.252.154]:26187 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbYAICWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:22:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QJkM3ujP6UOG+iATYsqNezSVJVGcLkdlQzdxJ9MREqojVJJpgNfONLTuXfUtDPjaJblPrjPhuk5z1fBEj9+V+OcOf5yjW+OtsbArZrPtnTpZuvjRUF1H80WUyVi5SYw9nqaMcmqshrDoYJSu9iC4PYYfwN8MUusZf/lRtoSWLJo=
Date: Wed, 9 Jan 2008 10:22:08 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: translations (Re: Kbuild update)
Message-ID: <20080109022208.GD2480@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080103213255.GA21811@uranus.ravnborg.org> <20080104132316.GA2485@hacking> <20080104143953.GA30536@uranus.ravnborg.org> <20080105054840.GB9976@does.not.exist> <20080106142606.GB2528@hacking> <20080106214136.GA24008@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080106214136.GA24008@flower.upol.cz>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>"I will use ...
>http://images.google.cz/images?svnum=100&um=1&hl=cs&client=firefox-a&rls=org.mozilla%3Acs%3Aofficial&q=I+will+use+Google+before&btnG=Hledat+obr%C3%A1zky
>... for making translations..."
>http://www.google.com/translate?u=http%3A%2F%2Flxr.linux.no%2Flinux%2FDocumentation%2FHOWTO&langpair=en%7Czh-TW&hl=en&ie=UTF8
>?
>
>In case if people will help Google to have better quality of translation,
>that will be better generally for much bigger number of *people*,
>especially in China, isn't it?

Perhaps yes.

But at least now, that kind of translation still sucks. It can
satisfy me.

>
>Making any official world-domination/new-world-order projects with
>Linux will not help IMHO. Very fast code flow and almost no up to date
>documentation is still relevant and google search + email archives
>are not going to be obsolete in the near future.
>
>Also, future of the linux codebase with Chinese comments in C or in
>ASM is kind of wired nightmare. Those, who cannot read actual source
>code (i.e. C) will not go too far.
>
>So, translation guys, maybe you will stop making noise and will start
>to make e.g. less buggy Linux? Greg KH have much more stuff to care,
>than some translations IMHO.

I never say to translate C comments. What we want to translate is the
strings in Kconfig.

I abosutely agree that we should focus on the exsiting bugs of Linux,
but like Greg's inclusion of some kernel doc translations, this kind
of work is really helpful to attract some kernel newbies from none
English-speaking countries. Even we can't make offical efforts,
the civil work, like TLKTP, is still worthy. Believe me, I am leading
a local LUG in my college and I found that one _big_ reason that why
the newbies are afraid of Linux kernel is English, instead of the
C tricks or low-level programming.

Regards.


 Cong

