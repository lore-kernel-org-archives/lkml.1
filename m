Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbZHPSTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbZHPSTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 14:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZHPSTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 14:19:11 -0400
Received: from rtr.ca ([76.10.145.34]:48209 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbZHPSTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 14:19:10 -0400
Message-ID: <4A884D9C.3060603@rtr.ca>
Date: Sun, 16 Aug 2009 14:19:08 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Worley <worleys@gmail.com>,
       Matthew Wilcox <matthew@wil.cx>, Bryan Donlan <bdonlan@gmail.com>,
       david@lang.hm, Greg Freemyer <greg.freemyer@gmail.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 slot is freed)
References: <200908122007.43522.ngupta@vflare.org>	 <20090813151312.GA13559@linux.intel.com>	 <20090813162621.GB1915@phenom2.trippelsdorf.de>	 <alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>	 <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>	 <alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>	 <3e8340490908131354q167840fcv124ec56c92bbb830@mail.gmail.com>	 <4A85E0DC.9040101@rtr.ca>	 <f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com>	 <20090814234539.GE27148@parisc-linux.org>	 <f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com>	 <1250341176.4159.2.camel@mulgrave.site> <4A86B69C.7090001@rtr.ca>	 <1250344518.4159.4.camel@mulgrave.site>	 <20090816150530.2bae6d1f@lxorguk.ukuu.org.uk>	 <20090816083434.2ce69859@infradead.org>	 <1250437927.3856.119.camel@mulgrave.site>  <4A8834B6.2070104@rtr.ca> <1250446047.3856.273.camel@mulgrave.site>
In-Reply-To: <1250446047.3856.273.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>
> Heh, OS writers not having access to the devices is about par for the
> current course.
..

Pity the Linux Foundation doesn't simply step in and supply hardware
to us for new tech like this.  Cheap for them, expensive for folks like me.

Cheers
