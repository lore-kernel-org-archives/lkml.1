Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbZAEAVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbZAEAVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 19:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZAEAVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 19:21:10 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:16894 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZAEAVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 19:21:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sy/FPizomo6mqKpYk8rHzsz1mcsbjfZcoOwkxcbhe69Hg7RPq+QJFQaOAqanMscNX2
         RM5uQ4+zrjuNDIVItH4xN857h3i0jJSLwGMOapk37uKII6gPzUGSdnfsnuRSGg4ay8k+
         zfTwlPP2PaYUc1c+X8PEEpHiy8Um7H0VkiPYU=
Message-ID: <8752a8760901041621o51380e91x9ef8414b22c40ffc@mail.gmail.com>
Date: Mon, 5 Jan 2009 00:21:06 +0000
From: "Ben Goodger" <goodgerster@gmail.com>
To: "David Newall" <davidn@davidnewall.com>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: david@lang.hm, "Kyle Moffett" <kyle@moffetthome.net>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linasvepstas@gmail.com, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>, burdell@iruntheinter.net
In-Reply-To: <496150DF.2070501@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <496076A9.7030907@davidnewall.com>
	 <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>
	 <4960897D.5030603@davidnewall.com>
	 <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>
	 <4961432A.80509@davidnewall.com>
	 <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>
	 <49614835.7000505@davidnewall.com>
	 <alpine.DEB.1.10.0901041702540.25545@asgard.lang.hm>
	 <496150DF.2070501@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/5 David Newall <davidn@davidnewall.com>:
>> another poster said that NTP packets include information about this
>> month's leap second, so that implies that they could change monthly.
>
> Not "could change monthly" rather, "could change at any month".
>
> The frequency of zoneinfo updates would therefore be: every time the
> zones you care about change; and every time there's a leap second.  No
> big effort.

Unfortunately, as has been pointed out, timezones are completely
unrelated to leap seconds.
NB. Leap seconds, positive or negative, potentially occur every six
months (June 30 or Dec 31), but since their introduction this
frequency has happened only once (in 1972); historically they have
been inserted on average every 1.5 years, but there have been only two
since 2000.

-- 
Benjamin Goodger

-----BEGIN GEEK CODE BLOCK-----
Version: 3.1
GCS/S/M/B d- s++:-- a18 c++$ UL>+++ P--- L++>+++ E- W+++$ N--- K? w---
O? M- V? PS+(++) PE-() Y+ PGP+ t 5? X-- R- !tv() b+++>++++ DI+++ D+ G
e>++++ h! !r*(-) y
------END GEEK CODE BLOCK------
