Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbZHWHvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbZHWHvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 03:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbZHWHvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 03:51:19 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:18804 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbZHWHvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 03:51:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TTs1fMpupKMYIhXDZLOw3T1dOblNYFEY5noZQSavzUXpAI/dLga+t8T8uGokfj397W
         DH7I38zD6lUjVkO1SHy052/hevZfnLUnYch9hLR8dGpu2TJyLOKzI6Lx4bzU8+Hufmmn
         VonpcVJBxUR4cWc+EmtO1nXO3veUSRR3D2z7g=
MIME-Version: 1.0
In-Reply-To: <9c9fda240908222145j1938baa3v3ecf8c5899ce3850@mail.gmail.com>
References: <5d5443650908221004y5b893382m368dc18a38636c1b@mail.gmail.com>
	 <4A902904.2090008@gmail.com>
	 <9c9fda240908222145j1938baa3v3ecf8c5899ce3850@mail.gmail.com>
Date: Sun, 23 Aug 2009 13:21:18 +0530
Message-ID: <5d5443650908230051wa8fa77cu280707281fe450ff@mail.gmail.com>
Subject: Re: haptics devices linux driver support
From: Trilok Soni <soni.trilok@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Sun, Aug 23, 2009 at 10:15 AM, Kyungmin Park<kmpark@infradead.org> wrote:
> Hi,
>
> There's three types as I know,
>
> 1) just GPIO enable motor
> 2) GPIO & PWM motor.
> 3) I2C based GPIO & PWM motor.
>
> Frankly we made a motor framework at kernel. but I 'm not sure motor
> is right naming or not.
> I think we need new framework. since it's not input device.

I am looking at 3rd type, and evaulating that for embedded systems
devices having haptics chips can be programmed under drivers/input or
not. It is kind of early discussion and gathering inputs on what could
be lacking part in input subsystem for support such category of
devices.

Is it possible for you to submit your version of code and drivers? It
will be good starting point for discussion.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
