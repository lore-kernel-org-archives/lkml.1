Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbXJ2Egv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbXJ2Egv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 00:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbXJ2Egn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 00:36:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35408 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbXJ2Egm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 00:36:42 -0400
Message-ID: <4725627E.4080104@zytor.com>
Date: Sun, 28 Oct 2007 21:33:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [REGRESSION] 2.6.24-rc1 fails to boot on a 486
References: <200710290005.l9T05wM5001672@harpo.it.uu.se>
In-Reply-To: <200710290005.l9T05wM5001672@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> My old 486 fails to boot with the 2.6.24-rc1 kernel.
> Grub loads it, 4 lines of text appear but not the kernel's
> "Linux version <blah> greet", and the machine reboots.
> Double-checked with a serial console: nothing appears
> before it reboots.

What four lines of text?

	-hpa
