Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbYIKQG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbYIKQG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 12:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYIKQGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 12:06:21 -0400
Received: from gw.goop.org ([64.81.55.164]:37501 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbYIKQGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 12:06:20 -0400
Message-ID: <48C941FA.50500@goop.org>
Date: Thu, 11 Sep 2008 09:06:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Ingo Molnar <mingo@elte.hu>, Alex Nixon <alex.nixon@citrix.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux/MIPS Development <linux-mips@linux-mips.org>
Subject: Re: [PATCH 0/3] Globally defining phys_addr_t
References: <48C8D76B.10901@goop.org> <Pine.LNX.4.64.0809111202560.1545@anakin>
In-Reply-To: <Pine.LNX.4.64.0809111202560.1545@anakin>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
>> PowerPC also defines a phys_addr_t with the same meaning as x86; the
>> powerpc arch maintainers are happy with these patches.
>>     
>
> If I'm not mistaking, this is also true for some MIPS machines.
>   

Nothing turns up in a grep over arch/mips and include/asm-mips.

    J
