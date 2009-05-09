Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbZEIRXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbZEIRXF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 13:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbZEIRWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 13:22:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:24571 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZEIRWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 13:22:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R2rXuVG4EEuX6MPZUPPlYdd3+xL6FXEWyVXvir0QJo5cCdC9veFQ/d0uiqjyJJ7T7/
         Seo7K9LMhCTegWTbEDySMD6soc7nr407k3VLMTPfpfdkUNnhKGKS07zY+fFLc0eEM4EN
         zHheJwAachSd7pWVVKLUaNEz/BOBEyLR/4BdA=
MIME-Version: 1.0
In-Reply-To: <4d34a0a70905081858y56dacf34of004301f93daf3e3@mail.gmail.com>
References: <4A012C64.1020101@samsung.com>
	 <20090508031859.GE30616@dtor-d630.eng.vmware.com>
	 <4d34a0a70905081858y56dacf34of004301f93daf3e3@mail.gmail.com>
Date: Sat, 9 May 2009 22:52:53 +0530
Message-ID: <5d5443650905091022k539654f7p31dd8c3191fccba8@mail.gmail.com>
Subject: Re: Input: add MAX7359 key switch controller driver
From: Trilok Soni <soni.trilok@gmail.com>
To: Kim Kyuwon <chammoru@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Kim Kyuwon <q1.kim@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

On Sat, May 9, 2009 at 7:28 AM, Kim Kyuwon <chammoru@gmail.com> wrote:
> Hi Dmitry,
>
> Thank you for good comments. I fixed all as you recommended. More
> detailed answers are below your comments.
> In addition, I also added wakeup related statements
> (device_init_wakeup, device_may_wakeup, [enable|disable]_irq_wake).
>
> I'm sending this revised patch right now.
>
> By the way, can I ask the same question which I ask to Trilok.

I thought I had explained it in my e-mail but Dmitry's reply is more
explanatory.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
