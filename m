Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbXJZGj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbXJZGj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 02:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbXJZGjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:39:49 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:28981 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbXJZGjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:39:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KgmPWEdVVEmyQ2Ehv12yi3FQVuVehd5ZFd1QtfIy16Cav+j/vZC+H/n0GvlPiKx9uh/cbpj5s/Vibk6NXt4R/1o6/+20hONmGKoR8xclKzdTHElkxKFuNXE4XJwrr+uQiDHraSkGvx3A1ybGn6eZkFz+6YUGsvtVKbOUD8IGYhw=
Message-ID: <86802c440710252339kcf5d46dh4602fff9ac8d3a66@mail.gmail.com>
Date: Thu, 25 Oct 2007 23:39:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 5/6] x86: move i386 and x86_64 Kconfig files to x86 directory
Cc: "Randy Dunlap" <rdunlap@xenotime.net>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
In-Reply-To: <20071026061425.GA19022@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071025195644.GA14501@uranus.ravnborg.org>
	 <20071025200546.GF14501@uranus.ravnborg.org>
	 <86802c440710251853w1b33ea66j13181664cb5a30a0@mail.gmail.com>
	 <20071025194653.46d39a13.rdunlap@xenotime.net>
	 <86802c440710252251v1ad07c12x22254c1b4ed3ceee@mail.gmail.com>
	 <20071026061425.GA19022@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> > but
> > in git
> >
> > http://git.kernel.org/?p=linux/kernel/git/sam/x86.git;a=commitdiff;h=d013a27cb79a01b324f93adb275162c244cca2de
> >
> > doesn't include that removing..
>
> That's the bug Kay noticed.
> It should not have been removed so I fixedit and pushed out a new change.
> Again - please see reply to Kay and read the [GIT PULL] mail.

Good. that compiles without problem on x86_64.

BTW:
why not using Kconfig.x86_32 instead of Kconfig.i386?

YH

YH
