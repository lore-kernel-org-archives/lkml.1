Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbZKGSM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbZKGSM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 13:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZKGSMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 13:12:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:14305 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZKGSMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 13:12:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZygPAij5xpEc2+PHcby6et2Ytcc0IQc1eaW3TSDCRjILDRQ+p/0LQZWZff7cEzbbp8
         flOQkoTyLGxiKjBroME8Y4zBPNd1gkSjYIksxD/1ArFFWe3hErkaERXzCaXViNYx/8C0
         eVZCKAma5w2dZePhYJgBugr9DLC9GFP7rYuFg=
MIME-Version: 1.0
In-Reply-To: <20091107173028.GA1932@ucw.cz>
References: <200911031951.05235.bzolnier@gmail.com>
	 <200911042251.23506.IvDoorn@gmail.com> <20091106074643.GA5562@ucw.cz>
	 <200911061858.56816.IvDoorn@gmail.com> <20091107173028.GA1932@ucw.cz>
Date: Sat, 7 Nov 2009 18:12:58 +0000
Message-ID: <efe7343f0911071012u73317883wc60f5c188bc853e8@mail.gmail.com>
Subject: Re: [announce] new rt2800 drivers for Ralink wireless & project tree
From: Luis Correia <luis.f.correia@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

On Sat, Nov 7, 2009 at 17:30, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> > > So if I want to focus on something different in the kernel, I just send 1 patch,
>> > > and a second to claim the maintainership of it even though there is an active
>> > > maintainer available?
>> >
>> > What about listing yourself as a maintainer for a start?
>>
>> The rt2x00 project is listed as maintainer for everything in the
>> drivers/net/wireless/rt2x00 folder.
>
> Yes, but that tells very little. I don't know who the 'rt2x00 project'
> is. Perhaps its you? Perhaps its Bart? Maybe its my cat? Please just
> list real names of maintainers...                 Pavel

the answer is (and always was available) here:

http://rt2x00.serialmonkey.com/wiki/index.php/Developers

Luis Correia
rt2x00 project admin
