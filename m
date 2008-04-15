Return-Path: <linux-kernel-owner+w=401wt.eu-S1764290AbYDOKR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764290AbYDOKR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 06:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbYDOKRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 06:17:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:26300 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212AbYDOKRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:17:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ja6hEawY3gH0SbMjrS+KCDf/vcqFuBlpNvsR7zA4jiwoEscTecjsaEd40xghhWFnxfkj1U2kbk0aiq98GXGrRSsE2qioS+iZmHtysE9MUz/EpBpXW0vPRBGuqrFHuQFqMvhzw9x6YtuODEDyg+PECHk2+LS0Q1nAr8fzOoZ4tiQ=
Message-ID: <544ab8580804150317k637118cp2cab91bfa1e37875@mail.gmail.com>
Date: Tue, 15 Apr 2008 12:17:17 +0200
From: "=?ISO-8859-1?Q?K=E1roly_Kasza?=" <kaszak@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: w35und: add softmac interface
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "kernel list" <linux-kernel@vger.kernel.org>, lcostantino@gmail.com,
       someone@dunanet.hu
In-Reply-To: <20080415091403.GA32652@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080414224740.GA31431@elf.ucw.cz>
	 <20080415002826.GC4270@tuxdriver.com>
	 <20080415070923.GA13767@elf.ucw.cz>
	 <544ab8580804150110x2f1841b4m7ebd43f1a6441458@mail.gmail.com>
	 <20080415091403.GA32652@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Last weekend we have started to rewrite the whole code based on
>  > rtl8187's softmac driver.
>
>  Hmm, I used adm* code as a template.
>

:)

>
>  Really take a look at those patches. I believe I'm pretty close to
>  dropping those upper layer code... Then, we'll be able to proceed
>  incrementally.
>
I commited them after some changes, please send patches next time
against the last revision :)
However I still think we should focus on rewriting the whole thing
instead of hacking this elder chaos.
I created /branches/softmac for the new code, You should extend that maybe?

KK
