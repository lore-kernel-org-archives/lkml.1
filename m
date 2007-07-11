Return-Path: <linux-kernel-owner+w=401wt.eu-S1762760AbXGKLE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762760AbXGKLE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759740AbXGKLEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:04:16 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:49485 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbXGKLEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:04:15 -0400
Message-ID: <4694B917.5040809@s5r6.in-berlin.de>
Date: Wed, 11 Jul 2007 13:03:51 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, rientjes@google.com,
       Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] try parent numa_node at first before using default
References: <200707101641.17672.yinghai.lu@sun.com> <200707101652.31378.yinghai.lu@sun.com> <4694B702.2050507@s5r6.in-berlin.de>
In-Reply-To: <4694B702.2050507@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
>   - device_move() should update the device.node.

device.numa_node of course.
-- 
Stefan Richter
-=====-=-=== -=== -=-==
http://arcgraph.de/sr/
