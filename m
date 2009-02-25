Return-Path: <linux-kernel-owner+w=401wt.eu-S1763854AbZBYXM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763854AbZBYXM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761973AbZBYXMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:12:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41000 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121AbZBYXMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:12:37 -0500
Message-ID: <49A5CF2E.6050306@zytor.com>
Date: Wed, 25 Feb 2009 15:07:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Arnd Bergmann <arnd@arndb.de>, Kyle McMartin <kyle@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] Make exported headers use strict posix types
References: <20090225032553.GD6690@bombadil.infradead.org> <49A4F051.3000706@zytor.com> <20090225072202.GI6690@bombadil.infradead.org> <200902251917.49017.arnd@arndb.de> <20090225201131.GA26110@uranus.ravnborg.org>
In-Reply-To: <20090225201131.GA26110@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>>
>> This is my previous patch, ported to today's git. It's my last day
>> before my vacation, so I can't do the usual testing etc. on it.
>> Hopefully somebody else can take care of this.
> 
> I hesitate to put it in kbuild.git... Any better place?
> 

I'll put it in tip:core/headers-fixes.

	-hpa
