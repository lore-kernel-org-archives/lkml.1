Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbXJ1WNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbXJ1WNa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbXJ1WNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:13:22 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57308 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbXJ1WNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:13:21 -0400
Date: Sun, 28 Oct 2007 23:13:20 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Markus Elfring <Markus.Elfring@web.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: No module symbols loaded - kernel modules not enabled.
In-Reply-To: <47250092.5070303@web.de>
Message-ID: <Pine.LNX.4.64.0710282310370.4125@fbirervta.pbzchgretzou.qr>
References: <fg2p69$t4p$1@ger.gmane.org> <Pine.LNX.4.64.0710282146440.17164@fbirervta.pbzchgretzou.qr>
 <47250092.5070303@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 28 2007 22:35, Markus Elfring wrote:
>
>> This message is added by klogd, and it is independent of CONFIG_KALLSYMS.
>> (Since I do have KALLSYMS=y while also getting that message. I suppose
>> it is because CONFIG_DEBUG_INFO=n)
>
>I could not find the message text in my kernel source directory so far. I had also no luck
>with a cross reference like "http://lxr.linux.no/search".
>Which source code is responsible for the notice?
>

Like I said, klogd. This seems to be outside the scope of LKML.
