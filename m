Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbYGUTla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbYGUTla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYGUTlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:41:23 -0400
Received: from czlug.icis.pcz.pl ([212.87.224.95]:49393 "EHLO
	czlug.icis.pcz.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbYGUTlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:41:22 -0400
Message-ID: <4884E644.9040701@czlug.icis.pcz.pl>
Date: Mon, 21 Jul 2008 21:40:52 +0200
From: Daniel Kubiak <sor@czlug.icis.pcz.pl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080522)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux based router Kernel Panic (2.6.23 - 2.6.26-rc9)
References: <48849FA7.9060604@czlug.icis.pcz.pl> <20080721151559.GA12604@martell.zuzino.mipt.ru>
In-Reply-To: <20080721151559.GA12604@martell.zuzino.mipt.ru>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan pisze:
> Enable CONFIG_KALLSYMS and CONFIG_DEBUG_BUGVERBOSE next time.
> 
> Or you can grab vmlinux of that kernel and decipher addresses by hand.
> 
I've got CONFIG_KALLSYMS and CONFIG_DEBUG_BUGVERBOSE set to yes, here is 
my kernel config http://www.sor.osiris.czest.pl/config-2.6.26-rc9-nat2


-- 
z poważaniem
Daniel Kubiak

jid/e-mail: sor@czlug.icis.pcz.pl
