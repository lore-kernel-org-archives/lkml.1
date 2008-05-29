Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbYE2Ew6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbYE2Ew6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 00:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYE2Ewt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 00:52:49 -0400
Received: from smtp08.mtu.ru ([62.5.255.55]:59960 "EHLO smtp08.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbYE2Ews (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 00:52:48 -0400
Message-ID: <483E36A3.3020308@aknet.ru>
Date: Thu, 29 May 2008 08:52:51 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ambx1@neo.rr.com, bjorn.helgaas@hp.com, david-b@pacbell.net, mingo@elte.hu,
       tglx@linutronix.de, dbrownell@users.sourceforge.net,
       rmk+lkml@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [patch][resend] provide rtc_cmos platform device, take 2
References: <200805212334.m4LNY42M006425@imap1.linux-foundation.org>	<483BEF1A.3080808@aknet.ru> <20080528163600.b4c3c12c.akpm@linux-foundation.org>
In-Reply-To: <20080528163600.b4c3c12c.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-DCC-STREAM-Metrics: smtp08.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andrew Morton wrote:
> It got lost from the changelog but IIRC this fixes a small sort-of regression
> which was added in 2.6.25(?) because Stas switched drivers.
The switch was behind my will (kconfig
changed), here's what David says:
http://uwsg.ucs.indiana.edu/hypermail/linux/kernel/0805.2/3467.html
http://uwsg.ucs.indiana.edu/hypermail/linux/kernel/0805.2/3060.html
