Return-Path: <linux-kernel-owner+w=401wt.eu-S1765261AbXGUMGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765261AbXGUMGo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 08:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762107AbXGUMGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 08:06:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:61385 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762057AbXGUMGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 08:06:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oDJT2IfHVfWsSou8JzPGIigQJZYJCujaHTjKc1E3C+44KD83MjjzqNASO98FENSa8nlKTAz8HA5BlG7WEKkAFLQyJ9uLPYkOuvNqlvuLJH1qAtJae2Tgzyj+CqRNOUVnnkBw+WBsgS5ZiFiKg6umdbEVWvLGxR72yCVYsRm5OTo=
Message-ID: <92a12cdb0707210506t5cf58cc4gc5b70f335545dc3f@mail.gmail.com>
Date: Sat, 21 Jul 2007 13:06:30 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: "Peter Bortas" <bortas@gmail.com>
Subject: Re: [PATCH] Fix DMA on Dreamcast
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lethal@users.sourceforge.net
In-Reply-To: <7e5f60720707210424w48f9dc10hff044d702f7bd1d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0707191230g216feaf2ied3e95bacf4dd572@mail.gmail.com>
	 <20070720120408.1f190269.akpm@linux-foundation.org>
	 <92a12cdb0707210322m6670acaer768d078c5e358b0c@mail.gmail.com>
	 <7e5f60720707210424w48f9dc10hff044d702f7bd1d3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/07, Peter Bortas <bortas@gmail.com> wrote:

>
> Sidenote: Does Linux handle the Dreamcast DMA errata?
>

You need to explain what you mean (at least to me!).

If you mean will it degrade gracefully - not without this patch if set
to the (correct) defconfig. With iffy settings it will.
