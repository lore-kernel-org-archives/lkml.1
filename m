Return-Path: <linux-kernel-owner+w=401wt.eu-S965895AbXG3BVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965895AbXG3BVA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 21:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965626AbXG3BUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 21:20:52 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:40690 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965624AbXG3BUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 21:20:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Mb6m7KwGQOSkGKRqJCyr4cc1i7lpRKXxx5hQC2r/97aqfCR5faFudGMbKoKm3nI1axNEydfadtvCnQ+OkL1fGVhXFu44ZXdAky7+osQGGF9YQlI1Mua+tX0O6OVfc9Ml1eWX8h5Tc6wBqJ7bBLFbklcm8jKzjlsAqtlOkonTDo8=
Message-ID: <b21f8390707291820k7bd3b55la41ba0bf582ea4ef@mail.gmail.com>
Date: Mon, 30 Jul 2007 11:20:46 +1000
From: "Matthew Hawkins" <darthmdh@gmail.com>
To: John <darknessenvelops@gmail.com>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Cc: "Ingo Molnar" <mingo@elte.hu>, ck@vds.kolivas.org,
       "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu>
	 <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com>
	 <20070729204716.GB1578@elte.hu>
	 <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/07, John <darknessenvelops@gmail.com> wrote:
> I understand that, I was just wondering if the FPS scales the same natively
> vs. Wine as I typically only run native games.  I have been hesitant to move
> over to CFS due to reports of 3D issues and wanted to see if you had numbers
> in regards to CFS vs. SD.

John, the numbers Ingo makes and the numbers you make will no doubt be
different (unless by some fantastic freak of nature you both have
identical systems).  Take this opportunity to do this testing yourself
so in case there is some improvement to make, it can be done for
2.6.23.  Nobody can benchmark your system but you.

Remember to set CONFIG_HZ to 1000

-- 
Matt
