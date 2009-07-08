Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbZGHElW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbZGHElW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbZGHElO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:41:14 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:48505 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbZGHElN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:41:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wk8lMV4Ae96hqIB/A5Ye6Lnbv4NFIyiPXHFbIYvnPjJTjVKi8i/7NeQRo15OyTdZ4u
         HegdNVq+ZOXSJe4BqbTGvxJGvtI0WXaclrBTSeB0iuNDpMYrfA8f16Aj4E6mO1TGLaNR
         3Jn6D8fz4paghFXSHC3/I6fzXXO8oOC43Wy8U=
MIME-Version: 1.0
In-Reply-To: <4A53B7DB.5050105@acm.org>
References: <20090703015554.GB5880@cr0.nay.redhat.com>
	 <412e6f7f0907030259m5556ee2fobbb58d377bce4d17@mail.gmail.com>
	 <4A4DDD54.9030206@free.fr>
	 <200907070643.56394.vda.linux@googlemail.com>
	 <412e6f7f0907070045o6a17fb10x557108ffde0da11@mail.gmail.com>
	 <4A53B202.9080505@davidnewall.com> <4A53B7DB.5050105@acm.org>
Date: Wed, 8 Jul 2009 12:41:11 +0800
Message-ID: <412e6f7f0907072141x6de32dddj139c7bc1435d3bf6@mail.gmail.com>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
From: Changli Gao <xiaosuo@gmail.com>
To: Zan Lynx <zlynx@acm.org>
Cc: David Newall <davidn@davidnewall.com>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Albert ARIBAUD <albert.aribaud@free.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 8, 2009 at 5:02 AM, Zan Lynx<zlynx@acm.org> wrote:
>
> But perhaps mkfifo(NULL) should be the syscall chosen to extend since its
> parameters are much like open() already, and it seems to work in the above
> sequence to create a one-FD FIFO already.
>
It sounds a good idea.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
