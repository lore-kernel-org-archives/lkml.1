Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZIGL3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZIGL3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 07:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbZIGL3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 07:29:54 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:54157 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbZIGL3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 07:29:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=asQRkLB3VwAoOsUyK37V+4CjfOt94CGhpxUHkX1+wx0IUCXpuma1ltus+O359QZ6fg
         4yKLVYkoLFnEExXaQUTn7r3axw9th9soVV1TVyfjRWRBdo6yh6meDWj7W9ZorJ9/kced
         VSRhJmxiOKTDUHpRbe8zFhe+rhqN6psObBXwk=
MIME-Version: 1.0
In-Reply-To: <5d5443650908230051wa8fa77cu280707281fe450ff@mail.gmail.com>
References: <5d5443650908221004y5b893382m368dc18a38636c1b@mail.gmail.com>
	 <4A902904.2090008@gmail.com>
	 <9c9fda240908222145j1938baa3v3ecf8c5899ce3850@mail.gmail.com>
	 <5d5443650908230051wa8fa77cu280707281fe450ff@mail.gmail.com>
Date: Mon, 7 Sep 2009 16:59:55 +0530
Message-ID: <5d5443650909070429q1eeb5b78t8398ba670143fbf9@mail.gmail.com>
Subject: Re: haptics devices linux driver support
From: Trilok Soni <soni.trilok@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Sun, Aug 23, 2009 at 1:21 PM, Trilok Soni<soni.trilok@gmail.com> wrote:
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

Any updates on my request ?

---Trilok Soni
