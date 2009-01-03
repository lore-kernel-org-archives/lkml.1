Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbZACEqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbZACEqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 23:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757772AbZACEqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 23:46:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:5996 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbZACEqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 23:46:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=hOGzvx7tLYP9epfrXpK6wrMrqMS2U1GgwOv0NHCyz5RPKfhHrwcCMoAyqOXr4dBwX4
         2xyXNH77Q6VkekciKKYi0fWySMZ1wByadEzzSCrYcSRjnvDOFo9i05yXZhjnNh1yeO13
         GRXtJV2p9B8QqokI/nDxYaXeTWtQ2OVIqAlsY=
Message-ID: <e9e943910901022046y436b39ay72ae7b898c0fe26f@mail.gmail.com>
Date: Sat, 3 Jan 2009 04:46:29 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Ben Goodger" <goodgerster@gmail.com>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: linasvepstas@gmail.com, linux-kernel@vger.kernel.org,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>, burdell@iruntheinter.net
In-Reply-To: <8752a8760901022002n7cd269a1k1073df66d0d2b08d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <3ae3aa420901021949m1df64dadh693ad39618476524@mail.gmail.com>
	 <8752a8760901022002n7cd269a1k1073df66d0d2b08d@mail.gmail.com>
X-Google-Sender-Auth: d20344c6646ee4b9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/3 Ben Goodger <goodgerster@gmail.com>:
> 2009/1/3 Linas Vepstas <linasvepstas@gmail.com>
>> > Slashdot reported a story of Linux machines crashing on New years eve.
>>
>> FYI, Looks like the bug has been found, and theres a patch!
>>
>> http://lkml.org/lkml/2009/1/2/389
>
> Great. I look forward to not crashing the next time it is 2008-31-31-23:59:59.
> Sarcasm aside, please pass on my thanks to Mr Griffin.

Thanks, but I'm not the one who deserves the thanks: Chris Adams did
all the work in reproducing and diagnosing the problem. My patch was
entirely trivial (and indeed, incomplete).

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
