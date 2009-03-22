Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbZCVEVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbZCVEVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 00:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbZCVEVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 00:21:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39190 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZCVEVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 00:21:05 -0400
Message-ID: <49C5BBE8.6010906@zytor.com>
Date: Sat, 21 Mar 2009 21:17:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Baybal Ni <nikulinpi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: My new fancy font for framebuffer
References: <ff479ab60903210945p51c78f4fgf434d159e880de95@mail.gmail.com> <20090321111520.5fb73195@infradead.org>
In-Reply-To: <20090321111520.5fb73195@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sat, 21 Mar 2009 16:45:19 +0000
> Baybal Ni <nikulinpi@gmail.com> wrote:
> 
>> I thought the default font to be boring and there is my linux port of
>> terminus font.
> 
> can you give some clarity of the copyrights around the terminus font?
> It'd nice to have pretty fonts.. but we need to make sure we're clear
> around the copyrights....
> 

Either way, the terminus font by Dimitar Zhekov is GPL 2.  This probably
means that distributing it without distributing the source format or
"the preferred form for editing" is illegal in jurisdictions where
bitmap fonts are copyrightable.  The preferred format for editing the
terminus font appears to be BDF.

That, combined with the sheer number of character subsets one can get
out of the extremely rich terminus font would again mean that the kbd
project is a better place for it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

