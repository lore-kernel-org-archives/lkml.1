Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYAFO02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYAFO02 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYAFO0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:26:20 -0500
Received: from ag-out-0708.google.com ([72.14.246.247]:30398 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbYAFO0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:26:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=dPNh5mPcZksGxvBaXLNfC+Nj6yQStm4snsdwDlZtmvjJHw0TOY4zpFup5Tujcq/4/cuNZmxGOaZC9MZOg+U/B2aTpM6oTPDRIkB0VGOJcoS10Q1WRjsOr/rZGr40c3OZrOpAOv5W88nwU8uIvUtB2dFIQ4j72VchrW+Mc/QsQbk=
Date: Sun, 6 Jan 2008 22:26:06 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild update
Message-ID: <20080106142606.GB2528@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080103213255.GA21811@uranus.ravnborg.org> <20080104132316.GA2485@hacking> <20080104143953.GA30536@uranus.ravnborg.org> <20080105054840.GB9976@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105054840.GB9976@does.not.exist>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> It sort of stopped at one point due to missing integration in mainline.
>> What I refer to is mostly the mconf.c bits, but I would also like to
>> see what lkml says to a sample of .po files included in the kernel
>> for a number of languages.
>> 
>> One criteria to get a .po file integrated could be at least 10% of the
>> strings translated or similar.

Well, I think it's worthy. The translation effort will be valuable
and much helpful for non-English-speaking peoples.

>
>Besides the initial translation efforts a big problem would be to 
>also find people who will regularly update the translations for
>many years.
>

Yes, that's really a problem. But I think the updates won't be
too frequent, only update for stable release is enough.

If we can make this to be an offical project for Linux kernel, I
think it won't be a big problem.

Regards.


 Cong

