Return-Path: <linux-kernel-owner+w=401wt.eu-S1764758AbYEOSwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764758AbYEOSwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763898AbYEOSuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:50:50 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:40124 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763856AbYEOSut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:50:49 -0400
Message-ID: <482C8606.6000308@hp.com>
Date: Thu, 15 May 2008 11:50:46 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Chris Peterson <cpeterso@cpeterso.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>	<20080515142154.0595e475@core>	<36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com>	<20080515173939.1ec968be@core> <482C7DA3.1090809@garzik.org>
In-Reply-To: <482C7DA3.1090809@garzik.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> 
> 
> The Treacherous Platform Module includes an RNG.
> 
> Someone (hi Jesse?) should implement support for TPM_GetRandom.
> 
> All the specs are public, and the hardware is already in users' hands.

I will not pretend to understand everything mentioned, but having web 
searched on "TPM RNG" I came across this:

http://www.mail-archive.com/cryptography@metzdowd.com/msg06299.html

which may either encourage or discourage depending on one's point of view.

rick jones
