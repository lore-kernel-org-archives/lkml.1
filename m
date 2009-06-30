Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbZF3Cmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbZF3Cmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 22:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZF3Cmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 22:42:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46274 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbZF3Cmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 22:42:44 -0400
Message-ID: <4A497B48.9020105@zytor.com>
Date: Mon, 29 Jun 2009 19:41:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Mikael Pettersson <mikpe@it.uu.se>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>	<19013.29264.623540.275538@pilspetsen.it.uu.se>	<4A45A5C1.5080701@zytor.com>	<19013.59956.144640.331854@pilspetsen.it.uu.se>	<20090629022911.GC20297@lackof.org>	<4A484A8A.9020704@zytor.com>	<19016.41349.636663.515540@pilspetsen.it.uu.se>	<20090629112155.GJ5480@parisc-linux.org> <19016.44061.600652.676183@pilspetsen.it.uu.se> <4A490804.3040609@zytor.com> <4A494478.7020304@kernel.org> <4A494E3C.70304@kernel.org> <4A495C0D.2020807@zytor.com> <4A4966EF.6010809@kernel.org> <4A4967CF.2080007@zytor.com> <4A496946.8080409@kernel.org>
In-Reply-To: <4A496946.8080409@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> how about start is already 32M ?
> you will insert blank one...
> 

I was rather assuming that zero range length was handled elsewhere...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

