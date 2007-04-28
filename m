Return-Path: <linux-kernel-owner+w=401wt.eu-S1030870AbXD1BlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030870AbXD1BlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030869AbXD1BlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:41:04 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:47750 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030870AbXD1BlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=onCnu4d1qcYXWC0KBfscEHUI0CHTiDmzo35fox8W+LQZVlzcLp6G0CJLr1PUe5czKasrJdu5eD2o9s/8JdRxUy9SF+tB24EIlUOLr72WBuuus2UiSWzwXhaiWnoMp8yx+cpJDzofCXFYNzhu3LWYMTjvtOnWdNPp01EGmdmRZKA=
Message-ID: <b6a2187b0704271840l4ca69b27v7c687b546c28dd15@mail.gmail.com>
Date: Sat, 28 Apr 2007 09:40:59 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "lkml777@123mail.org" <lkml777@123mail.org>
Subject: Re: Question about Reiser4 (how to boot it?)
Cc: linux-kernel@vger.kernel.org, "Eric Hopper" <hopper@omnifarious.org>,
       "William Heimbigner" <icxcnika@mar.tar.cc>,
       "Alex Zarochentsev" <zam@namesys.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Rik van Riel" <riel@redhat.com>,
       "Edward Shishkin" <edward@namesys.com>
In-Reply-To: <1177717116.1762.1186993177@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070423111939.c876c9cc.akpm@linux-foundation.org>
	 <20070424193921.GA17129@one.firstfloor.org>
	 <462F6717.70508@namesys.com>
	 <b6a2187b0704250749s2a00dadep93b2943bc0b9df9d@mail.gmail.com>
	 <1177564182.15467.1186637743@webmail.messagingengine.com>
	 <b6a2187b0704252348t1242560dqad6a1d30e665abc5@mail.gmail.com>
	 <b6a2187b0704260118x7cf8ed57mab9a12d06a2471a9@mail.gmail.com>
	 <1177658163.8094.1186854037@webmail.messagingengine.com>
	 <b6a2187b0704270937g18f305cdxfdd54349fb73f3ea@mail.gmail.com>
	 <1177717116.1762.1186993177@webmail.messagingengine.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/07, lkml777@123mail.org <lkml777@123mail.org> wrote:
> Thanks, that is certainly helpful, but that only mounts one directory
> (partition) as Reiser4.
>
> This I have already done.
>
> I was more interested in how to have a whole partition dedicated to
> Reiser4 and being able to boot into it.

Not able to boot a whole partition with grub2. I've seen patch for
grub ... ftp://ftp.namesys.com/pub/reiser4progs/grub-0.97-reiser4-20050808.tar.gz

But I since I'm using grub2, it's not possible to boot directly into
reiser4. I'm only use the whole 250GB partition on my 2nd hard disk
for testing.

I'm as interested as you in looking for grub2 to boot directly.
Currently, I've to create a small ext2 partition for grub2.

Jeff.
