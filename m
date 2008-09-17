Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYIQV2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYIQV2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYIQV2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:28:35 -0400
Received: from pih-relay04.plus.net ([212.159.14.17]:46102 "EHLO
	pih-relay04.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbYIQV2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:28:35 -0400
Message-ID: <48D17681.4040109@yahoo.com>
Date: Wed, 17 Sep 2008 22:28:33 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: How how latent should non-preemptive scheduling be?
References: <48D1741A.7010508@yahoo.com>
In-Reply-To: <48D1741A.7010508@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 4f6f1b7f8127fe7b37a2a604cfde47fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
> I have an EeePC 900 (Intel Celeron 900Mhz) and it seems to be skipping 
> while playing sound through various desktop apps with a 2.6.27rc6 
> kernel. It is running off an SD card which really shows up slow writes 
> but the sound is seemingly skipping even when ext3 is not being used. 
> When look at latencytop I often see results similar to this:

One other small datapoint. When the skipping starts to occur regularly 
it seems to be exactly 30 seconds apart. ALSA doesn't report any xruns 
either...
