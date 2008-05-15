Return-Path: <linux-kernel-owner+w=401wt.eu-S1763782AbYEOSST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763782AbYEOSST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYEOSSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:18:04 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:39614 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYEOSSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:18:02 -0400
Message-ID: <482C7E53.3050300@hp.com>
Date: Thu, 15 May 2008 11:17:55 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Peterson <cpeterso@cpeterso.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>	<20080515142154.0595e475@core>	<36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com> <482C7B18.6060003@garzik.org>
In-Reply-To: <482C7B18.6060003@garzik.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there nothing associated with the networking stack - NIC, driver, 
protocols, system calls which can be used as a source of entropy?

rick jones
