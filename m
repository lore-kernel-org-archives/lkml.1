Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbXF0HQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbXF0HQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 03:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757290AbXF0HQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 03:16:24 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:50403 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603AbXF0HQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 03:16:22 -0400
Date: Wed, 27 Jun 2007 09:20:03 +0200
From: DervishD <lkml@dervishd.net>
To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: Problems with fb console [was Re: 2.6.12-rc4-mm2]
Message-ID: <20070627072003.GC14083@DervishD>
Mail-Followup-To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <20050516021302.13bd285a.akpm@osdl.org> <20070627023527.5e643e32@werewolf-wl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070627023527.5e643e32@werewolf-wl>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi J.A. :)

 * J.A. Magallón <jamagallon@ono.com> dixit:
> kernel /boot/vmlinuz video=vesafb:mtrr,ywrap vga=0x31A ro root=/dev/sdc1
> 
> (tried both with hex and decimal).

    Try "vga=0x031A". I vaguely remember I had a similar problem and
IIRC that's how I solved it. Anyway, you can always try vga=ask and try
to enter the number by hand, just to see which modes work.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
