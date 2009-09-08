Return-Path: <linux-kernel-owner+w=401wt.eu-S1750893AbZIHOay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893AbZIHOay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZIHOax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:30:53 -0400
Received: from lucidpixels.com ([75.144.35.66]:39900 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZIHOax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:30:53 -0400
Date: Tue, 8 Sep 2009 10:30:55 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Christoph Hellwig <hch@infradead.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Felix Blyakher <felixb@sgi.com>
Subject: Re: [Bug #13949] Cryptoloop stuck I/O issue on partition or loopback
 device
In-Reply-To: <20090907152553.GA21768@infradead.org>
Message-ID: <alpine.DEB.2.00.0909081029050.7636@p34.internal.lan>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera> <hKF51Pczj6N.A.bvH.Y3BpKB@chimera> <20090907152553.GA21768@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Sep 2009, Christoph Hellwig wrote:

> On Sun, Sep 06, 2009 at 08:11:51PM +0200, Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.29 and 2.6.30.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
>> be listed and let me know (either way).
>
> While this still isn't fixed it has been tracked down to a regression
> in the loop driver.  Care to adjust the subject?
>

Unsure how to edit on the kernel bugtracker but updating this thread to 
correct the subject.

