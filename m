Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbZEFKZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbZEFKZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 06:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZEFKZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 06:25:19 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34943 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZEFKZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 06:25:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rjj562lWqICqLJfKZ/HqCb09fgRyekDlaIkyeGAqHAvoItcGrpEUMP7BZNe6K5pbFG
         j9I/ZaBqy27kXLyECLnFByXc7CDLntQZuYfW8uDVBTIO65M86qAGo6x1QTQE57EAwTUj
         s4kxqOMjP4pV5JWZde8z+OtKCUTEx19LLUImQ=
MIME-Version: 1.0
In-Reply-To: <20090506071839.GA14412@elte.hu>
References: <4A0136F4.4010504@kernel.org> <20090506071839.GA14412@elte.hu>
Date: Wed, 6 May 2009 12:25:16 +0200
Message-ID: <c62985530905060325s32c36081xe4e7850c287a9731@mail.gmail.com>
Subject: Re: printk %0*X is broken.
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/6 Ingo Molnar <mingo@elte.hu>:
>
> Cc:-ed more folks who modified lib/vsprintf.c recently.
>
>        Ingo


Thanks, I will look at it this evening.
