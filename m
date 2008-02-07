Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbYBGKHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbYBGKHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYBGKHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:07:46 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:36882 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbYBGKHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:07:46 -0500
Date: Thu, 7 Feb 2008 13:07:34 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: tg3 broken after "PCI: Fix bus resource assignment on 32 bits with 64b resources"
Message-ID: <20080207100734.GB29127@localhost.sw.ru>
References: <20080204151222.GB25790@localhost.sw.ru> <1202162073.7079.8.camel@pasglop> <20080205091758.GB26618@localhost.sw.ru> <86802c440802050207j60385efbif6f693dc0b1fd297@mail.gmail.com> <1202244592.7079.68.camel@pasglop> <20080206100510.GA29127@localhost.sw.ru> <1202332526.7079.86.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202332526.7079.86.camel@pasglop>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 08:15:26AM +1100, Benjamin Herrenschmidt wrote:
> 
> > 
> > BTW, "[PATCH] x86_32: fix regression caused by trim ram according to mtrr on system with 4G more RAM"
> > http://marc.info/?l=linux-kernel&m=120229095121673&w=2
> > fixes this box too and I have back all 4G of RAM as a bonus. :-)
> 
> You mean you no longer have a problem or does your tg3 issue still
> stand ?

tg3 is fine now, thanks everyone. :)

