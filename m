Return-Path: <linux-kernel-owner+w=401wt.eu-S1763005AbYEARMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763005AbYEARMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbYEARMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:12:23 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:38412 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbYEARMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:12:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/3] Add dma_set_mask_weak() API
Date: Thu, 1 May 2008 19:11:40 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       John Linville <linville@tuxdriver.com>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200805011638.15910.mb@bu3sch.de> <200805011640.17281.mb@bu3sch.de> <20080501172045.35686f43@core>
In-Reply-To: <20080501172045.35686f43@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011911.41388.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 May 2008 18:20:45 Alan Cox wrote:
> On Thu, 1 May 2008 16:40:16 +0200
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > This adds a new DMA subsystem API call for "weak" setting
> > of the DMA mask
> 
> weak is an odd term - and we use weak for things like weak symbols so it
> might be confusing. dma_request_mask() ?

Yeah, as a non-native english speaker I couldn't come up with a good
name for it. But request seems pretty good to me.


-- 
Greetings Michael.
