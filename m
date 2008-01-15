Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbYAOBez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbYAOBez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 20:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbYAOBeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 20:34:46 -0500
Received: from ro-out-1112.google.com ([72.14.202.180]:4300 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYAOBeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 20:34:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=RvbCNkVZssq2Ngi1KlElyOnOfHnM7F7nvrNvcw+GjkiVMcEEQczdiPtsTmGMFyLuHdGw4hdpQqCZrZ05efxJAL/+fbV/P3HDXTe9GN61Vw1+jabVmJYxAW1ub/0Wms/zWMvccjPFbGiKx14sjr2bwCT5986jwOe0by94veFHbx0=
Date: Tue, 15 Jan 2008 09:33:47 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: translations (Re: Kbuild update)
Message-ID: <20080115013347.GA3112@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080103213255.GA21811@uranus.ravnborg.org> <20080104132316.GA2485@hacking> <20080104143953.GA30536@uranus.ravnborg.org> <20080105054840.GB9976@does.not.exist> <20080106142606.GB2528@hacking> <20080106214136.GA24008@flower.upol.cz> <20080109022208.GD2480@hacking> <20080109135024.GD24008@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109135024.GD24008@flower.upol.cz>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
>ftp://flower.upol.cz/upload/Configure.help
>
>OK, please, take a look at stuff, Korean guys did 5-6 years ago. One
>particular ARM port (S3C2410X) along with an ARM bootloader (vivi) was
>done. Yet for some reason official Linux port has another developers, and,
>it seems, it was done some time (~1-2 years) later.

I glanced at the page. I don't know Korean, but it seems OK.
What do you mean by saying this? I can't catch your points.


>> I abosutely agree that we should focus on the exsiting bugs of Linux,
>> but like Greg's inclusion of some kernel doc translations, this kind
>> of work is really helpful to attract some kernel newbies from none
>> English-speaking countries. Even we can't make offical efforts,
>> the civil work, like TLKTP, is still worthy.
>...
>
>> Believe me, I am leading a local LUG in my college and I found that one
>> _big_ reason that why the newbies are afraid of Linux kernel is
>> English, instead of the C tricks or low-level programming.
>
>IMHO, there is so much stuff done, that any brilliant C or whatever-asm
>coder *have* to study at least something of it. And, in order to do a
>valuable contribution, one must know the work-flow, people *and* English.
>This is usually done by reading mailing list *and* archives for quite
>some time. This takes time, this takes effort, but this also have huge
>impact on intelligence and culture of the `coders'.
>
>Do you ever have a question about why History exists and is studied on
>all levels of education? Same with programming. Without
>history-via-English, one have no strong roots, thus base for grow and
>flower.

I think you've overstated.

Translation does _not_ mean avoiding learning English. I agree with
what you said above about English. But just as you said, it needs
_time_ and translation *is* a good way to help this. I, myself,
began to learn computer English by reading the translations of some
famous English textbooks, and then reading the original ones.


>OTOH, Internet has so much noise and crap all over the place, that
>information is very hard to find. It takes much time to sort and see it.
>Yet, providing noise generating, like in-tree translations, seems, is a
>very easy way around (not taking maintaining in account).

Translations can be put in .po files.

Thanks.

 Cong

