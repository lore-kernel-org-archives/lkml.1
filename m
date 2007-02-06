Return-Path: <linux-kernel-owner+w=401wt.eu-S933179AbXBFSnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbXBFSnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXBFSna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:43:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:10563 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbXBFSn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:43:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,291,1167638400"; 
   d="scan'208"; a="43576762:sNHT17828757"
Message-ID: <45C8CC2A.90403@linux.intel.com>
Date: Tue, 06 Feb 2007 19:42:50 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Marc Donner <donner@dbd-breitband.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: cpu load balancing problem on smp
References: <200702061832.17771.donner@dbd-breitband.de> <1170785364.7324.31.camel@laptopd505.fenrus.org> <200702061941.32907.donner@dbd-breitband.de>
In-Reply-To: <200702061941.32907.donner@dbd-breitband.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Donner wrote:
>>
>> see http://www.irqbalance.org to get irqbalance
> 
> I now have tried irqloadbalance, but the same problem.


can you send me the output of

cat /proc/interrupts

(taken when you are or have been loading the network)

maybe there's something fishy going on
