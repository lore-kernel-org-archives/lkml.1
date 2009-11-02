Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbZKBT2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbZKBT2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756586AbZKBT2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:28:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40963 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369AbZKBT2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:28:03 -0500
Date: Mon, 2 Nov 2009 20:27:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, laijs@cn.fujitsu.com,
       davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 7/7] vsprintf: factor out skip_space code in a
	separate function
Message-ID: <20091102192706.GA30939@elte.hu>
References: <b8bf37780911020926p77ca30d1maa4384f21323adb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8bf37780911020926p77ca30d1maa4384f21323adb@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* André Goddard Rosa <andre.goddard@gmail.com> wrote:

> >From 584d9bfc7c1d41b76a05655b4562b98fcbef6ee4 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
> Date: Sun, 1 Nov 2009 14:09:06 -0200
> Subject: [PATCH v2 7/7] vsprintf: factor out skip_space code in a
> separate function
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit

btw., for reviewability's sake, could you please fix your patch 
submission method to not include such garbled headers in the mail body?

(Also, it would be nice to reply-thread the 7 patches on the 0/7 mail, 
as git-send-email does.)

Thanks,

	Ingo
