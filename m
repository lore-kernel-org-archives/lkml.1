Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbYJRUlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbYJRUlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYJRUln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:41:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:6139 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYJRUlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gANa18KwN/kd5Q+xQmgNH5CK6mF0UhkkczL/5K8GcKVJLl2bgmBvhza/TYYs4cjWa5
         ICuR0ghroTPvEgWbSekaTVyfcv9u16vO8LLHzU3Y1VoCbu48qSeeBD0ZnTi59J2cpuct
         Q84pH8iquWBrNfRdWmqHn2IU3uw8Jpjdvb260=
Message-ID: <6179c79b0810181341g584d0466s6a2abb68b786be38@mail.gmail.com>
Date: Sat, 18 Oct 2008 22:41:41 +0200
From: "Piotr Skamruk" <piotr.skamruk@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH v3] Add SPI over GPIO driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Magnus Damm" <magnus.damm@gmail.com>,
       "David Brownell" <david-b@pacbell.net>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200810181132.24233.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807202146.12759.mb@bu3sch.de> <200810171318.32306.mb@bu3sch.de>
	 <20081017213631.82c49b3a.akpm@linux-foundation.org>
	 <200810181132.24233.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/18 Michael Buesch <mb@bu3sch.de>:
> On Saturday 18 October 2008 06:36:31 Andrew Morton wrote:
>> This patch has some "issues" a month or so ago.  Current status is that
>
> yeah, upstream maintainers don't like these patches.
> Please drop this one and the "gpiommc" patch now.
>
As i remember - David stands that these patches (or even
functionality) are not usable for him, so he don't want to see them in
mainstream kernel sources. It's his choice, he is maintainer of this
subsystem.

You have this on openwrt svn, I have it on my dev gittree - and as You
can see on Magnus example - anybody interested can google for it.
Maybe if there will be next few peoples - David will change his
opinion on this subject...
