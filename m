Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbZHXQhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbZHXQhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZHXQhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:37:00 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40260 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbZHXQg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LBQpnX8HzL4iTw7vGgYF0B051oyOTEBbfPIVQTq3RWcQUTRvuhF7GBm9qlQEH/C5+M
         lWDHqfDpc2gDc1xGfTcJ0W24nb9eihzaks64ERzEC0Q0L5uJGrt64A+b2vOAYbsUPWJ7
         rKuoSXdFzJAFMuQOWNgZgGla327vi+MkxKEUo=
MIME-Version: 1.0
In-Reply-To: <5d5443650908230051wa8fa77cu280707281fe450ff@mail.gmail.com>
References: <5d5443650908221004y5b893382m368dc18a38636c1b@mail.gmail.com> 
	<4A902904.2090008@gmail.com> <9c9fda240908222145j1938baa3v3ecf8c5899ce3850@mail.gmail.com> 
	<5d5443650908230051wa8fa77cu280707281fe450ff@mail.gmail.com>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Mon, 24 Aug 2009 17:36:32 +0100
Message-ID: <45cc95260908240936y2f8c1e24h6c8b031c898fd551@mail.gmail.com>
Subject: Re: haptics devices linux driver support
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Kyungmin Park <kmpark@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am interested to know real examples of haptic devices you speak about.
It would be nice if you send some links or pics.

I remember there was the same problem categorizing other input devices
like accelerometers.

Thanks


On Sun, Aug 23, 2009 at 8:51 AM, Trilok Soni<soni.trilok@gmail.com> wrote:
> Hi Kyungmin,
>
> On Sun, Aug 23, 2009 at 10:15 AM, Kyungmin Park<kmpark@infradead.org> wrote:
>> Hi,
>>
>> There's three types as I know,
>>
>> 1) just GPIO enable motor
>> 2) GPIO & PWM motor.
>> 3) I2C based GPIO & PWM motor.
>>
>> Frankly we made a motor framework at kernel. but I 'm not sure motor
>> is right naming or not.
>> I think we need new framework. since it's not input device.
>
> I am looking at 3rd type, and evaulating that for embedded systems
> devices having haptics chips can be programmed under drivers/input or
> not. It is kind of early discussion and gathering inputs on what could
> be lacking part in input subsystem for support such category of
> devices.
>
> Is it possible for you to submit your version of code and drivers? It
> will be good starting point for discussion.
>
>
> --
> ---Trilok Soni
> http://triloksoni.wordpress.com
> http://www.linkedin.com/in/triloksoni
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
