Return-Path: <linux-kernel-owner+w=401wt.eu-S965686AbXBHFTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965686AbXBHFTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 00:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965709AbXBHFTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 00:19:32 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56017 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965686AbXBHFTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 00:19:31 -0500
Date: Wed, 7 Feb 2007 21:19:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>, sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kai Germaschewski <kai@germaschewski.name>
Subject: Re: dd
Message-Id: <20070207211921.1f0220a4.akpm@linux-foundation.org>
In-Reply-To: <20070208052439.GL22699@flower.upol.cz>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru>
	<Pine.LNX.4.64.0702071846180.14457@scrub.home>
	<20070207220435.GC22699@flower.upol.cz>
	<Pine.LNX.4.64.0702080029030.14457@scrub.home>
	<Pine.LNX.4.64.0702071546420.8424@woody.linux-foundation.org>
	<20070207203047.51a95ad0.akpm@linux-foundation.org>
	<20070208052439.GL22699@flower.upol.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 06:24:40 +0100 Oleg Verych <olecom@flower.upol.cz> wrote:

> If that matter, `type -path' is bashizm (BloAted SHell), and "blackbox"
> with "dash" (very good `sh' equivalents) will fail.

Does the kernel presently build with that shell?
