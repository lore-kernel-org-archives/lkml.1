Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYG1N13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYG1N13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 09:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYG1N1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 09:27:20 -0400
Received: from mailout07.yourhostingaccount.com ([65.254.253.61]:56735 "EHLO
	mailout07.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbYG1N1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 09:27:20 -0400
X-Greylist: delayed 2258 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jul 2008 09:27:20 EDT
X-EN-OrigOutIP: 10.1.18.2
X-EN-IMPSID: vQpa1Z00602goRm0000000
Message-ID: <488DC046.7060802@writeme.com>
Date: Mon, 28 Jul 2008 08:49:10 -0400
From: Sinan Akman <sinan@writeme.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Karsten Keil <kkeil@suse.de>
CC: Marcel Holtmann <marcel@holtmann.org>, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       David Miller <davem@davemloft.net>
Subject: Re: mISDN still breaking the allmodconfig build...
References: <20080727.170235.97056809.davem@davemloft.net>	<93120C4B-D2F4-4479-806B-2141AC3DC607@holtmann.org>	<20080727.180736.74131389.davem@davemloft.net>	<7949EA87-4340-4353-AFC9-79A718B95DF0@holtmann.org> <20080728084024.GA23465@pingi.kke.suse.de>
In-Reply-To: <20080728084024.GA23465@pingi.kke.suse.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 9579962fb128fd4edc0e15f211ef4629:b3dd9e212e2067e834de66fc17565494
X-EN-AuthUser: remote@bootbits.com
X-EN-OrigIP: 69.157.241.192
X-EN-OrigHost: bas12-montrealak-1167978944.dsl.bell.ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten Keil wrote:
> [...]
> virt_to_bus() I never got a complain before and yes I already have some patches
> to solve the endian issues in the HFC driver, but it was not finaly

   Karsten, do you have those patches available somewhere ?
I could give it a try on  4xx with a 4s card in the near future.

   Thanks

   Sinan Akman

