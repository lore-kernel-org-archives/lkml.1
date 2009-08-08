Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbZHHB72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbZHHB72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 21:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbZHHB71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 21:59:27 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:52106 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZHHB70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 21:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YgacvXEijBxtFqugehRggrK11LzFITXk4mzbyB4mK4Q8SfFbbGWj2X3a1iEsLybp3W
         k4wUal4cCgwPentvqhoWGvshO5a2vpMuw/azveH9Ab6I+YsoHhnfizHhv51+TpwKqVp3
         a6iwZD0tXMrItfMPQ45Qdqhok2Fc8cygLoeo8=
MIME-Version: 1.0
In-Reply-To: <20090807094944.eed4bfb8.akpm@linux-foundation.org>
References: <200908060733.n767X6mN023120@imap1.linux-foundation.org>
	 <20090807134659.GA2093@darkstar>
	 <20090807094944.eed4bfb8.akpm@linux-foundation.org>
Date: Sat, 8 Aug 2009 09:59:24 +0800
Message-ID: <a8e1da0908071859m129e4938wfb27d747cd7cc302@mail.gmail.com>
Subject: Re: mmotm 2009-08-06-00-30 uploaded
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 8, 2009 at 12:49 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
> On Fri, 7 Aug 2009 21:47:00 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> Hi, andrew
>>
>> Booting with this release, init (maybe getty?) reports something like:
>>
>> INIT: open /dev/console failed with input/output error
>>
>> 2.6.31-rc5 is fine.
>>
>> Any hints to find the root problem?
>
> Not really, sorry.  Might be tty changes in linux-next?
>
>> Another problem:
>>
>> When I moving mouse or pressing key the screen will become black, then restore the normal screen.
>
> There have been quite a lot of X problems lately.
>
> Could you test the bare linux-next please?
>

Thanks, will do

-- 
Regards
dave
