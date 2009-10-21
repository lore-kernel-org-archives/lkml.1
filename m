Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbZJUGZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbZJUGZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 02:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZJUGZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 02:25:15 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:31408 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbZJUGZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 02:25:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=rRejxhCwyACsT3Q5R0Qddqpxle5Iy14FLWilMQQJby3tLnxoGcI7StnJ1PpouRQQqv
         fbLyczBmbnz3CBe3QYG8QjC0Tdj5nPaxr2/VP80IjdMXGDIriPhTJF9MI2ekAC66iORD
         qAxzT/yBSqI1TKEl/Hmh1KKmQOPZcSbG4J8u0=
MIME-Version: 1.0
In-Reply-To: <df9815e70910202324o1af88a3cg82093fc5e0bf7929@mail.gmail.com>
References: <df9815e70910202204q5a0593e1gd14b9d36c368861e@mail.gmail.com>
	 <1256105727.9801.105.camel@ben-desktop>
	 <df9815e70910202324o1af88a3cg82093fc5e0bf7929@mail.gmail.com>
Date: Wed, 21 Oct 2009 14:25:18 +0800
Message-ID: <df9815e70910202325r1004ef7exe7bed24e1fc14a17@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 
	0000000000000004
From: Jike Song <albcamus@gmail.com>
To: Ben Nizette <bn@niasdigital.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 2:15 PM, Ben Nizette <bn@niasdigital.com> wrote:
> On Wed, 2009-10-21 at 13:04 +0800, Jike Song wrote:
>
>> Pid: 3427, comm: Xorg Tainted: G      D    2.6.32-rc5-00011-g2fdc246
>
> the "D" means this isn't the first oops/bug since boot; please post all
> bugs and/or full dmesg.  Given all the invalid ioctl noise an Xorg
> version might help too.
>
> Thx,
>        --Ben.

Ben,

Thank you for telling me this. The whole dmesg output is attached.

--
Thanks,
Jike
