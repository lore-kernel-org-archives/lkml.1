Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYHDMzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYHDMzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 08:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYHDMy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 08:54:56 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54987 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbYHDMyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 08:54:55 -0400
Date: Mon, 4 Aug 2008 15:53:38 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, michael@free-electrons.com,
       Matt Mackall <mpm@selenic.com>, netdev@vger.kernel.org,
       davem@davemloft.net, akpm@linux-foundation.org
Subject: Re: [patch 4/4] Configure out IGMP support
Message-ID: <20080804125338.GG6088@cs181140183.pp.htv.fi>
References: <20080731092703.661994657@free-electrons.com> <20080731093221.565015353@free-electrons.com> <1217619715.3454.488.camel@pmac.infradead.org> <20080804144807.6b2374d9@surf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080804144807.6b2374d9@surf>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 02:48:07PM +0200, Thomas Petazzoni wrote:
> Le Fri, 01 Aug 2008 20:41:55 +0100,
> David Woodhouse <dwmw2@infradead.org> a écrit :
> 
> > The config option probably lives in net/Kconfig, not init/Kconfig.
> 
> Yes, it could. But AFAIK, until now, all CONFIG_EMBEDDED-related
> options have been put in init/Kconfig.
>...

No, the vast majority is actually outside of init/Kconfig.

> Sincerly,
> 
> Thomas

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

