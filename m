Return-Path: <linux-kernel-owner+w=401wt.eu-S1757664AbZCQRb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664AbZCQRb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 13:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbZCQRbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 13:31:48 -0400
Received: from mail-qy0-f122.google.com ([209.85.221.122]:47781 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbZCQRbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 13:31:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hgg7Ygc05yYPo4+SSqmylNsLkgEo6dne4Lo1Byqc0vBRUUrWJjob8Pgh1u+y6K1r6O
         UbW7KV1jf03Bimr0bdcC25C29Wtc6t3WpI0McZQuA7HdrlVD/zyF9VnZJGBH4h9FnMpZ
         gdB08UJF7hziVPzMB9eHCe8Wi51nr5QIlyksQ=
MIME-Version: 1.0
In-Reply-To: <b6a2187b0903171027w328f1dfds781910c0571b2424@mail.gmail.com>
References: <1237143683.24621.7.camel@johannes.local>
	 <alpine.LFD.2.00.0903161250080.3082@localhost.localdomain>
	 <b6a2187b0903161655q15437156qc926c8db37d8ba4b@mail.gmail.com>
	 <20090317144802.GF3549@tuxdriver.com>
	 <20090317152801.GA6737@tuxdriver.com> <20090317153924.GA21061@elte.hu>
	 <20090317160527.GB6737@tuxdriver.com>
	 <b6a2187b0903170924u72723220x4c0a717e3cfebf8d@mail.gmail.com>
	 <20090317171047.GF6737@tuxdriver.com>
	 <b6a2187b0903171027w328f1dfds781910c0571b2424@mail.gmail.com>
Date: Wed, 18 Mar 2009 01:31:42 +0800
Message-ID: <b6a2187b0903171031l3657dc93rbfe01dd4dc9b7a4@mail.gmail.com>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 1:27 AM, Jeff Chua
>> Perhaps you have a dirty tree?
>>        git checkout -f
>
> May be. Checking now.

Oh, now I know why. I was "mucking" the SSID stuffs trying to revert
some of the wireless codes on 2.6.29-rc8, and just applied your
patches on top.

My downloaded tree is clean. I'm trying your patches now.

Jeff.
