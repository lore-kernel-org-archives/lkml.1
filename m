Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbXJ1RPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbXJ1RPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbXJ1RPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:15:24 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49653 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXJ1RPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:15:23 -0400
Date: Sun, 28 Oct 2007 18:15:22 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Markus Elfring <Markus.Elfring@web.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Check dependencies for modules "dm-snapshot" and "sd_mod" in
 kernel 2.6.23.1
In-Reply-To: <fg2fhb$tev$1@ger.gmane.org>
Message-ID: <Pine.LNX.4.64.0710281815020.30465@fbirervta.pbzchgretzou.qr>
References: <fg2b7g$1hj$1@ger.gmane.org> <Pine.LNX.4.64.0710281700360.30465@fbirervta.pbzchgretzou.qr>
 <fg2fhb$tev$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 28 2007 18:05, Markus Elfring wrote:
>
>> Perhaps your personal configuration is missing the
>> modules SUSE 10.3 requires. I'd use one of their rpms anyway.
>
>I have assumed that my Linux distribution is clean enough to try out a current kernel.
>Would you like to recommend anything to get rid from these warnings about unresolved
>dependencies?

If you really have to roll your own kernel (often this is not the case-YMMV),
I suggest you enable dm-snapshot and sd_mod.
