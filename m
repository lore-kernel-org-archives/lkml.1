Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab0BYBwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 20:52:47 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62790 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab0BYBwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 20:52:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kzmtB81jESMpqag3VjRrqacgzwFnfxFqi73bUr4/VEUdepcO6/kqnM8lOpjDjUiQFq
         uAhLqseH+VJ61xs3yJYZb557AEniB/WRbkoAheCyd9IUMv6opNSAM8rK/5LVuCr551Fd
         p8WAvY55D/A1d50xpn3c0NVgPoXePp8m4m3Y8=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a1002221125pb3836e6nc82cee09f2709467@mail.gmail.com>
References: <20100222141934.GA9030@darkstar>
	 <8bd0f97a1002221125pb3836e6nc82cee09f2709467@mail.gmail.com>
Date: Thu, 25 Feb 2010 09:52:44 +0800
Message-ID: <a8e1da1002241752s7c16a96eu11ceb5558390257f@mail.gmail.com>
Subject: Re: [PATCH 03/06] kernel.h hexdump cleanup
From: Dave Young <hidave.darkstar@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 3:25 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Mon, Feb 22, 2010 at 09:19, Dave Young wrote:
>> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
>> +++ linux-2.6/include/linux/hexdump.h   2010-02-16 17:33:16.000000000 +0800
>> @@ -0,0 +1,30 @@
>> +#ifndef _HEXDUMP_H
>> +#define _HEXDUMP_H
>
> use _LINUX_HEXDUMP_H to match other linux/ headers ?
> -mike
>

Thanks, either is fine for me.

-- 
Regards
dave
