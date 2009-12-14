Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbZLNOqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbZLNOqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZLNOqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:46:22 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:54406 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbZLNOqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:46:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=fBXeuaI338gMvuDIqPayckFd4evo5ZXYWIsUD21h0f1uVGlFNdFU33kX6ffBqTYEWy
         e9XnCTD9Eo/FcODBj+/IF2k/6+15C27VYcQ6F3WBei+cV7OMqBM0dQB0D7LmSNm2FzO7
         nVCfs/evNEOoIqNeDdS711fMPSoGnRKxR2yv0=
MIME-Version: 1.0
In-Reply-To: <20091214075115.GA29677@elte.hu>
References: <20091212105554.GA9345@elte.hu>
	 <1260691319-4683-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <20091214075115.GA29677@elte.hu>
Date: Mon, 14 Dec 2009 23:46:20 +0900
X-Google-Sender-Auth: 43d9f6a2291b3b3a
Message-ID: <a6b9f31a0912140646k48d8bddnd3540c87fe3dd59a@mail.gmail.com>
Subject: Re: [PATCH v2] perf bench: Add "all" pseudo subsystem and "all" 
	pseudo suite
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 16:51, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
>
>> Sorry, you are right, Ingo.
>> This was my careless miss. sched-pipe.c returned twice.
>> I wronged gcc by a false charge, sorry :(
>
> Dont worry about it too much - GCC is guilty enough times :)

Oh +)

>
>> This is version 2.
>
> Great patch, applied, thanks!

I received email from tip-bot, thanks!
    Hitoshi
