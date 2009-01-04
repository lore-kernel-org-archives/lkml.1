Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbZADWGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbZADWGf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 17:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZADWG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 17:06:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:31292 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZADWGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 17:06:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=aUfm7fjW04oMg8kY5L31E0bt+V80jZH0jrQ9093yZ4oliUHUTqTV1SfnpDFrGid3Wi
         F9qSBkgReh+RB/khzkn+Y/ZRQJUdJpaZPkgvQwSlWFPtaD8BZHzRL/Zu6DSidwmt7t4y
         tb+uDX4xJgPFtuY7hKOv/XOM20NAZbU6cb7NA=
Message-ID: <e9e943910901041406s6a74925ek45af128ba91e1965@mail.gmail.com>
Date: Sun, 4 Jan 2009 22:06:21 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Theodore Tso" <tytso@mit.edu>, "Duane Griffin" <duaneg@dghda.com>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>, Valdis.Kletnieks@vt.edu,
       "=?WINDOWS-1252?Q?Martin_MOKREJ=8A?=" 
	<mmokrejs@ribosome.natur.cuni.cz>,
       "Pavel Machek" <pavel@suse.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
In-Reply-To: <20090104215519.GC22958@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495FF9CE.2020908@ribosome.natur.cuni.cz>
	 <495FFECB.5040001@ribosome.natur.cuni.cz>
	 <e9e943910901031641x4c900b6ar5d0f50b648584b7b@mail.gmail.com>
	 <15786.1231041158@turing-police.cc.vt.edu>
	 <e9e943910901040624y69c01b43p1655c0078b969ea6@mail.gmail.com>
	 <20090104184040.GC17558@mit.edu>
	 <Pine.LNX.4.64.0901042015230.31141@anakin>
	 <20090104193637.GB22958@mit.edu>
	 <e9e943910901041151x4f251224w63df1e6237ec48cb@mail.gmail.com>
	 <20090104215519.GC22958@mit.edu>
X-Google-Sender-Auth: e058da1be4aa348f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/4 Theodore Tso <tytso@mit.edu>:
> On Sun, Jan 04, 2009 at 07:51:27PM +0000, Duane Griffin wrote:
>>
>> If anyone is interested I'd be happy to dust off and send them my old
>> patches to implement this. There are a couple of issues with it.
>> First, I never got around to implementing remount R/W support. Second,
>> I had to introduce a rather nasty hack in order to handle un-escaping
>> JFS magic numbers.
>
> Can you dust off the patches and send a copy to
> linux-ext4@vger.kernel.org so we have them archived someplace where
> hopefully someone might have time to look at it?

OK, will do. I've posted them there before, but not the latest version
that properly handles un-escaping JFS magic numbers (albeit in an ugly
way). I'll rebase them on top of the latest ext4 patch queue and
repost.

>                                          - Ted

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
