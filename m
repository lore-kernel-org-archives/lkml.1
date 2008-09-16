Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYIPV2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYIPV2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 17:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYIPV2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 17:28:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:19044 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbYIPV2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 17:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=r+n+ZOHUwMcq8wdaaK2l5B4r6B/5SLEkb1d7yUp3egGDXbVjfCrxK3WJvtgrNy/r5p
         PEttmO3attZbIxP2I0a9jSSXn4ur4losAWi/1JmfOcdw7RU8MRmisQfwq5f9b2lXkifN
         d3TO7yYo9AQ3do+b12L0n6ogBjYDtlL/WMrI8=
Message-ID: <86802c440809161428j2dfc9669g229a5bf23da63f34@mail.gmail.com>
Date: Tue, 16 Sep 2008 14:28:06 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] add DEFINE_LOGLEVEL_SETUP v3
Cc: "Marcin Slusarz" <marcin.slusarz@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48D022B0.5080402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221588085-30578-1-git-send-email-yhlu.kernel@gmail.com>
	 <1221588085-30578-2-git-send-email-yhlu.kernel@gmail.com>
	 <20080916190224.GA6115@joi>
	 <86802c440809161404v4b59f1c8se1ac61f982a15dd@mail.gmail.com>
	 <48D022B0.5080402@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 2:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> will come out one new version that hpa likes
>>
>> printk(KERN_PCI KERN_DEBUG "sadfasf\n");
>>
>
> Come to think about it, it might help migration pains if we put the prefixes
> in the opposite order (KERN_DEBUG KERN_PCI).
>
according to the code flow, these two is the same... will double check it.

YH
