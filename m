Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbZDPI17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbZDPI17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 04:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZDPI1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 04:27:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821AbZDPI1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 04:27:43 -0400
Date: Thu, 16 Apr 2009 01:24:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Zankel <chris@zankel.net>
Cc: Johannes Weiner <jw@emlix.com>, linux-kernel@vger.kernel.org
Subject: Re: Xtensa patches
Message-Id: <20090416012447.fd6e6dee.akpm@linux-foundation.org>
In-Reply-To: <49E6E155.6090000@zankel.net>
References: <1239702080-14355-1-git-send-email-jw@emlix.com>
	<49E6E155.6090000@zankel.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 00:42:13 -0700 Chris Zankel <chris@zankel.net> wrote:

> Hi Andrew,
> 
> I will look over those patches and commit them to xtensa-2.6.
> 

OK.  I have a random pile if i-dont-know-what xtensa stuff here.

xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-variant-specific-code.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-s6000-dma-engine-support.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver-fix.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
xtensa-add-m41t62-rtc-to-s6105-platform.patch
xtensa-enable-m41t80-driver-in-s6105_defconfig.patch

I'll drop xtensa-add-flat-support-checkpatch-fixes.patch (as I usually
do when someone merges the base patch but doesn't run checkpatch on it
- hint) and I'll send the rest over at you.

