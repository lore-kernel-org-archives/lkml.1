Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYJIBOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYJIBOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 21:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbYJIBOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 21:14:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51039 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbYJIBOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 21:14:03 -0400
Message-ID: <48ED5AD6.1080003@redhat.com>
Date: Wed, 08 Oct 2008 21:13:58 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Davi Leal <davi@leals.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: free tg3 ethernet driver
References: <200810082353.31033.davi@leals.com>
In-Reply-To: <200810082353.31033.davi@leals.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davi Leal wrote:
> We would like to have a tg3 driver which would be accepted as free by the 
> FSF's standards.

I would like a pony.

> At least some part of the driver seems to be GPL'ed; see [1].  However, the 
> FSF's hardware guide lists tg3 as non-free, so there seems to be a non-free 
> firmware somewhere.
> 
>  [1]
>  http://www.broadcom.com/support/ethernet_nic/driver-sla.php?driver=570x-Linux

Firmware blobs aren't news.  They've been discussed at great length on 
this list.  If you want to whine about this, whine to Broadcom.

> We would like to be able to use the free driver with Linux 2.6.27 or later.

You must be new here.

> Donation pledge group at
>   http://gnuherds.org/pledges?id=58
> Current donations: $101 USD

Gigabit NICs with firmware-free drivers cost $10.  If you care that much 
about the binary blob in tg3, maybe you should stop giving your money to 
Broadcom, and start giving it to vendors whose drivers satisfy your 
requirements.

-- Chris
