Return-Path: <linux-kernel-owner+w=401wt.eu-S1763983AbYCGPZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763983AbYCGPZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 10:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbYCGPZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 10:25:30 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:50700 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760AbYCGPZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 10:25:29 -0500
Date: Sat, 08 Mar 2008 00:25:57 +0900 (JST)
Message-Id: <20080308.002557.51867582.anemo@mba.ocn.ne.jp>
To: hans-christian.egtvedt@atmel.com
Cc: linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, hskinnemoen@atmel.com,
       avictor.za@gmail.com
Subject: Re: [PATCH] at73c213: Monaural support
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <47D13185.4080803@atmel.com>
References: <20080307.190234.55730878.nemoto@toshiba-tops.co.jp>
	<47D13185.4080803@atmel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Mar 2008 13:13:57 +0100, Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:
> This works fine for me on AT32AP7000 on STK1000 as well.

Thanks, good news.

> Although, I had to use 32 * 1024 buffer_bytes_max and 16 * 1024
> period_bytes_max. Higher buffer_bytes_max resulted in glitching sound
> when only using one channel. Nothing to do with this patch.

Hmm, it sounds strange.  But I still do not understand sound buffer
management well...

---
Atsushi Nemoto
