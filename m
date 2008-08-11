Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbYHKWLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbYHKWLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758496AbYHKWLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:11:21 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:48550 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758389AbYHKWLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:11:20 -0400
Message-ID: <48A0B905.20603@hp.com>
Date: Mon, 11 Aug 2008 15:11:17 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: David Miller <davem@davemloft.net>, cl@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: tbench regression on each kernel release from 2.6.22 -> 2.6.28
References: <48A086B6.2000901@linux-foundation.org>	<20080811.141501.01468546.davem@davemloft.net>	<48A0B037.501@linux-foundation.org>	<20080811.145047.105665450.davem@davemloft.net> <48A0B571.7010903@intel.com>
In-Reply-To: <48A0B571.7010903@intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> David Miller wrote:
> 
>>From: Christoph Lameter <cl@linux-foundation.org>
>>Date: Mon, 11 Aug 2008 16:33:43 -0500
>>
>>
>>>Maybe what we are seeing is general bloat in kernel execution paths
>>>due to the growth in complexity?
>>
>>It could be, and any kind of analysis into this would be great.
> 
> 
> perhaps Rick Jones who maintains netperf could enlighten us on some historic
> numbers? he usually seems to be happy to prop up new netperf numbers :)

While this is an excellent opening to talk about how netperf 
top-of-trunk can now emit keyword=value results easier (ostensibly) to 
put into a database then the regular or even CSV output formats, I 
cannot fully exploit it by pointing at a database of results :(

rick jones
