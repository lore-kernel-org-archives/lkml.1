Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZKCIwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZKCIwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 03:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbZKCIwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 03:52:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:59630 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbZKCIwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 03:52:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH] asm-generic: Fix typo in asm-generic/unistd.h.
Date: Tue, 3 Nov 2009 09:52:17 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       liqin.gnu@gmail.com
References: <OF0014BE26.A8597F3B-ON48257663.0009191F-48257663.000C690A@sunplusct.com>
In-Reply-To: <OF0014BE26.A8597F3B-ON48257663.0009191F-48257663.000C690A@sunplusct.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Message-Id: <200911030952.17483.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19lpch+6rNfpDc8/8tpsPv/8o+KKBntW1MPTqM
 0AKy3dbWvZ1FjZvKRM/uYTs/zoKXGwfpHNS4SbqmypKu5Q3hLu
 K/6wsxdrxYRsJf0zGV6uw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 November 2009, liqin.chen@sunplusct.com wrote:
> asm-generic headers could run on linux/score platform well,
> we upgradge libc to glibc-2.5 and passed LTP testsuites.
> we will gradually release score-linux toolchain on our website

Ah, good to hear!

Is there any reason to use glibc-2.5 though? The current release
is 2.10.1, and the version you used is over three years old.

Do you have plans to merge your port into eglibc when it's done?

	Arnd <><
