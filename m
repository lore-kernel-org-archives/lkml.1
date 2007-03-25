Return-Path: <linux-kernel-owner+w=401wt.eu-S1750863AbXCYOdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750863AbXCYOdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 10:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbXCYOdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 10:33:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:50620 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbXCYOc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 10:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tQ6NhLp4A/IhFmylmCt7oQ0NFEfEFjYClLZUJBTXFWsn8KLgVVUTXy0UTQHvBauy/d9B19NU3i7cKW753YfRGfUVneGRx+lxlmO5W0Xp0/VcVHIs/Fvy9OUzArTzTN+65cpdNBO6nEqb4uL8fIdQZN0cB7a4fdaNYTUGjnEfs6U=
Message-ID: <82e4877d0703250732pfe0bebdh97456c7d61f525d6@mail.gmail.com>
Date: Sun, 25 Mar 2007 10:32:56 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: keyboard.c: Stop flooding dmesg with useless warnings
Cc: "Dmitry Torokhov" <dtor@insightbb.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703251113390.21880@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703242315160.492@paragw-desktop>
	 <200703250115.02029.dtor@insightbb.com>
	 <82e4877d0703242227q7961833aie851e14764002264@mail.gmail.com>
	 <200703250129.32877.dtor@insightbb.com>
	 <82e4877d0703242235r7c83a867hd4f3ec740e8627fb@mail.gmail.com>
	 <Pine.LNX.4.64.0703251113390.21880@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/07, Jiri Kosina <jkosina@suse.cz> wrote:
> First, is there any specific kernel version where this started to happen
> to you, or is this long-standing bug you have been experiencing with older
> kernels too?

I am not sure about specific kernel version but I think this (2.6.20)
is the first kernel which gives me problems. It had not happened with
any previous versions.
I am compiling latest git to see if I have the problem with it - will
let you know how that goes.

>
> It would be useful if you could compile your kernel with CONFIG_HID_DEBUG
> and send the output both from the time the keyboard is connected and also
> when things go wild.

Yes, trying that out - will post the output soon.

Thanks!

Parag
