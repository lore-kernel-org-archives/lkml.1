Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbZHQCD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbZHQCD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 22:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbZHQCD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 22:03:26 -0400
Received: from rtr.ca ([76.10.145.34]:60923 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbZHQCDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 22:03:25 -0400
Message-ID: <4A88BA6C.7050902@rtr.ca>
Date: Sun, 16 Aug 2009 22:03:24 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Chris Worley <worleys@gmail.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Bryan Donlan <bdonlan@gmail.com>, david@lang.hm,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 	slot is freed)
References: <200908122007.43522.ngupta@vflare.org>	 <alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>	 <3e8340490908131354q167840fcv124ec56c92bbb830@mail.gmail.com>	 <4A85E0DC.9040101@rtr.ca>	 <f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com>	 <20090814234539.GE27148@parisc-linux.org>	 <f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com>	 <87f94c370908141730y3ddcb7bbj65d24b612fc0e96d@mail.gmail.com>	 <f3177b9e0908141738n5f99b85dx3de0f620180a4b46@mail.gmail.com>	 <4A86B605.5060701@rtr.ca> <f3177b9e0908161552o37c8f3b9k55806dd26864659@mail.gmail.com>
In-Reply-To: <f3177b9e0908161552o37c8f3b9k55806dd26864659@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Worley wrote:
..
> The OS should not assume a dumb algorithm on the part of the drive.
..

Welcome to the Real World.
