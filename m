Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab0BDRhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:37:10 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:62769 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933221Ab0BDRgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:36:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Lr5Vc3nhZtaXvH27sDqMbCmmHoo3mJ6D/C9sxVMTdRT+5/f2t6tAOBKdPi3sCNOhea
         RP34TLEFLFgk40Ntb+fnoLPO7sB3kJnKCIzLJyZp3j1MRqNV/hAoYw97cFs19F41hC+I
         rJ1bU55v6ztZBasf6g+HMfNX7GDfa3hBNHg8E=
MIME-Version: 1.0
In-Reply-To: <20100204082428.GA21938@elte.hu>
References: <20100203202425.GC1367@aftab> <20100204082428.GA21938@elte.hu>
Date: Thu, 4 Feb 2010 09:29:37 -0800
Message-ID: <590657101002040929r760bd01ei2695430d425fc6cd@mail.gmail.com>
Subject: Re: mtrr/state.c unused?
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       x86 <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 4, 2010 at 12:24 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Might be a dead code artifact from the original unification.
>
> Thanks,
>
>        Ingo

I dimly recall there was another user at the time, not that I've
actually gone back and looked
however.

Cheers,

Harvey
