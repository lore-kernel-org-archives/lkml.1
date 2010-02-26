Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303Ab0BZLYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:24:04 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:40518 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934595Ab0BZLYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:24:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=sOds8byZtWSQWzDzW1HKK5M1w2FOwQvP0RQUmY6JB7/z6tXE3PUnhsHovML0/CJJWa
         vstkwZSP31rUUsS2njpvE2piBP4/P4AgpRiuNBx3K4g1UOfWoLq7H2SqR+vUKKYf85j4
         18IBKjI8n0WCHjhmliwysRYHZH4XlVtTIi5tE=
MIME-Version: 1.0
In-Reply-To: <ff13bc9a1002260308k319d34b5y4757fcfb36106278@mail.gmail.com>
References: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>
	 <4B845AEE.5080604@zytor.com>
	 <ff13bc9a1002240156x27e28764mb6ba24da0b125d81@mail.gmail.com>
	 <20100226101423.GA25641@elte.hu>
	 <ff13bc9a1002260308k319d34b5y4757fcfb36106278@mail.gmail.com>
Date: Fri, 26 Feb 2010 12:23:58 +0100
X-Google-Sender-Auth: 20f8dbefcaf9bd2c
Message-ID: <ff13bc9a1002260323k6b3f38ah4f0505e401dcf77d@mail.gmail.com>
Subject: Re: [PATCH 0/5] x86-32: improve atomic64_t functions (v2)
From: Luca Barbieri <luca@luca-barbieri.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sent patches, both to conditionally perform the test and implement the
functions for x86 and x86-64.
