Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZKGTnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZKGTnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 14:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZKGTnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 14:43:47 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:60487 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbZKGTnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 14:43:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Vvhvg0L+RgnyDCh/wI9hrfbFwF11PBoGTwJsphZ3hea3FY3MxJzMIg/T5/3ONUSmrN
         1NK81Zuyrlu9apL0O9fnSVCuNBeIaXJB9Pg2try3/my2dwdh3u24j4YHszxxLHDq6b90
         8/eSXODeIVCes8Uv9ZDzjojKW4nR9KH9KSlwk=
MIME-Version: 1.0
In-Reply-To: <efe7343f0911071012u73317883wc60f5c188bc853e8@mail.gmail.com>
References: <200911031951.05235.bzolnier@gmail.com> <200911042251.23506.IvDoorn@gmail.com> 
	<20091106074643.GA5562@ucw.cz> <200911061858.56816.IvDoorn@gmail.com> 
	<20091107173028.GA1932@ucw.cz> <efe7343f0911071012u73317883wc60f5c188bc853e8@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 7 Nov 2009 11:43:32 -0800
Message-ID: <43e72e890911071143m58eb312ck8e95edc7228ca07f@mail.gmail.com>
Subject: Re: [announce] new rt2800 drivers for Ralink wireless & project tree
To: Luis Correia <luis.f.correia@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Ivo van Doorn <ivdoorn@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 7, 2009 at 10:12 AM, Luis Correia <luis.f.correia@gmail.com> wrote:
> Pavel,
>
> On Sat, Nov 7, 2009 at 17:30, Pavel Machek <pavel@ucw.cz> wrote:
>> Hi!
>>
>>> > > So if I want to focus on something different in the kernel, I just send 1 patch,
>>> > > and a second to claim the maintainership of it even though there is an active
>>> > > maintainer available?
>>> >
>>> > What about listing yourself as a maintainer for a start?
>>>
>>> The rt2x00 project is listed as maintainer for everything in the
>>> drivers/net/wireless/rt2x00 folder.
>>
>> Yes, but that tells very little. I don't know who the 'rt2x00 project'
>> is. Perhaps its you? Perhaps its Bart? Maybe its my cat? Please just
>> list real names of maintainers...                 Pavel
>
> the answer is (and always was available) here:
>
> http://rt2x00.serialmonkey.com/wiki/index.php/Developers
>
> Luis Correia
> rt2x00 project admin

BTW is the rt2x00 project a non-profit? If not then that copyright
notice on the files is pretty pointless as it would have no legal
backing.

  Luis
