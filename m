Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbZCRMyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbZCRMyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZCRMyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:54:36 -0400
Received: from norkia.v3.sk ([92.240.234.41]:55009 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZCRMyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:54:36 -0400
Message-ID: <36697.89.102.207.186.1237380871.squirrel@mail.v3.sk>
In-Reply-To: <20090318120458.GA1601@elte.hu>
References: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com>
    <20090317120112.GP6159@amd.com> <20090318093847.GC5879@elte.hu>
    <20090318115615.GS6159@amd.com> <20090318120458.GA1601@elte.hu>
Date: Wed, 18 Mar 2009 08:54:31 -0400 (EDT)
Subject: Re: e1000e 0000:00:19.0: DMA-API: device driver tries to free DMA 
     memory it has not allocated [device address=0x0000000052ff084a] 
     [size=90 bytes]
From: "Lubomir Rintel" <lkundrak@v3.sk>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Joerg Roedel" <joerg.roedel@amd.com>, netdev@vger.kernel.org,
       jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
       bruce.w.allan@intel.com, peter.p.waskiewicz.jr@intel.com,
       john.ronciak@intel.com, e1000-devel@lists.sourceforge.net,
       "Ingo Molnar" <mingo@redhat.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Reply-To: lkundrak@v3.sk
User-Agent: SquirrelMail/1.4.8-5.el5_2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, March 18, 2009 8:04 am, Ingo Molnar wrote:
>
> ( e1000e Cc:s added. A new debug feature, CONFIG_DMA_API_DEBUG=y,
>   has triggered the warning below in e1000_put_txbuf(). )

http://lkml.org/lkml/2009/3/2/318

-- 
Lubomir Rintel

