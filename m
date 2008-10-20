Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYJTXyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYJTXyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYJTXy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:54:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:44262 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYJTXy2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:54:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Rg+zj+ScPNhBLyLUJ5wfnTXDC+SF+1tgp5G8Xc7YJkFHwun2D62KL5wVExU2xCUhBO
         zwiPPyplrAg/wCKncH8g5KqVUMH7gqU6uJQD3RdHpl6VR2j4fXpkDQbDrlMW/rHgfW6f
         VhgzUdYYOMviFprN4nqCe2pAwGjXbZ+3tFgRw=
Message-ID: <2bfaaf400810201654u21c9d950o72b2afa9496ba3da@mail.gmail.com>
Date: Mon, 20 Oct 2008 21:54:26 -0200
From: "Alexandre Lymberopoulos" <lymber@gmail.com>
To: "=?ISO-8859-1?Q?Rog=E9rio_Brito?=" <rbrito@ime.usp.br>
Subject: Re: Bug#502583: scary messages in dmesg
Cc: 502583@bugs.debian.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081018060400.GB916@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <2bfaaf400810172145g4aba4827l87a19e67b9742815@mail.gmail.com>
	 <20081018060400.GB916@ime.usp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 4:04 AM, Rogério Brito <rbrito@ime.usp.br> wrote:
> Hi, Alexandre.

Hi there, Rogério!

> As these messages indicate something going wild in kernelland (due to the
> stack trace), I'm CC'ing the linux-kernel mailing list. It is probably
> triggered by something probably not related to usbmount.

Ok...

> Just for extra information, what kind of fs do you have on your memory
> stick? Can you provide extra details on the situation?

It's not a memory stick, it's a hard disk with ext3 file system. I
just plugged it it and the disk was automatically mounted in /dev/ext3
with no abnormal messages in dmesg. That weird messages appeared when
I unpplugged the disk (without umounting it, as it should be done when
using usbmount, right?).

When mounted I got a message asking for a fsck to be run on disk
because of many mount/umount processes without performing that
procedure.

By the way I think I've lost no data, but that messages are pretty
scary. I'm sorry I can't help that much, since I'm no more that a user
and big fan of Linux.

> Regards, Rogério Brito.
>
> P.S.: Alexandre's complete dmesg is available at
> http://bugs.debian.org/502583

Thanks for caring about this bug (if it is a bug).

Regards, Alexandre
-- 
===============================================================================
Alexandre Lymberopoulos - lymber@gmail.com
===============================================================================
