Return-Path: <linux-kernel-owner+w=401wt.eu-S1762545AbXERQzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762545AbXERQzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbXERQz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:55:29 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60168 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbXERQz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:55:28 -0400
Message-ID: <464DDA40.6010101@zytor.com>
Date: Fri, 18 May 2007 09:54:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: young dave <hidave.darkstar@gmail.com>
CC: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org>	 <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com>	 <a8e1da0705180154v37e8ec5fs2cc4de9417cd44d2@mail.gmail.com> <a8e1da0705180307m60a91996r91c8bfcd1c863a94@mail.gmail.com>
In-Reply-To: <a8e1da0705180307m60a91996r91c8bfcd1c863a94@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

young dave wrote:
> Hi,
> 
> After installation the new mm1 kernel, My system can not boot, the rc1
> kernel works ok.
> 
> The cursor just blinks after appearing "Bios data check successful"
> message.
> 
> what do you think about this?

"Bios data check successful" is not a message that comes from Linux, nor
from the boot loader.

Since you have left absolutely zero details about your system or
anything else, there isn't much anyone can do about it.

	-hpa

