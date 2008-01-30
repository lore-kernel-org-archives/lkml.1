Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYA3NXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYA3NXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbYA3NXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:23:10 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:46711 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYA3NXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:23:09 -0500
Date: Wed, 30 Jan 2008 14:23:08 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: ARP Bug?
In-Reply-To: <67062.74127.qm@web52004.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0801301422180.15249@fbirervta.pbzchgretzou.qr>
References: <67062.74127.qm@web52004.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30 2008 04:44, Matti Linnanvuori wrote:
>>On Jan 30 2008 04:29, Matti Linnanvuori wrote:
>>Jan Engelhardt:
>>>> If you have the same subnet on multiple interfaces, only the
>>>> first interface will be served.
>>>
>>>Does that comply with the standard?
>>
>>What standard?
>
>ARP standard. I think it is RFC 826:
>An Ethernet Address Resolution Protocol

Please quote the section where it says that routing implementations
MUST round-robin over a group of interfaces with same subnet.
