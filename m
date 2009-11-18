Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZKRD1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZKRD1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 22:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbZKRD1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 22:27:24 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:14250 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607AbZKRD1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 22:27:16 -0500
Message-ID: <4B03697F.9090200@chelsio.com>
Date: Wed, 18 Nov 2009 08:56:55 +0530
From: Rakesh Ranjan <rakesh@chelsio.com>
Organization: Chelsio Communications
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Mike Christie <michaelc@cs.wisc.edu>
CC: open-iscsi@googlegroups.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@suse.de,
       David Miller <davem@davemloft.net>, Karen Xie <kxie@chelsio.com>,
       Rakesh Ranjan <rakesh@chelsio.com>
Subject: Re: [RFC-PATCH] libiscsi dhcp handler
References: <4B014F95.8000906@chelsio.com> <20091116.051835.125328285.davem@davemloft.net> <4B01577E.2020003@chelsio.com>
In-Reply-To: <4B01577E.2020003@chelsio.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2009 03:29:16.0718 (UTC) FILETIME=[4EA41CE0:01CA67FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rakesh Ranjan wrote:
> David Miller wrote:
>> From: Rakesh Ranjan <rakesh@chelsio.com>
>> Date: Mon, 16 Nov 2009 18:41:49 +0530
>>
>>> Herein attached patches to support dhcp based provisioning for iSCSI
>>> offload capable cards. I have made dhcp code as generic as possible,
>>> please go through the code. Based on the feedback I will submit final
>>> version of these patches.
>> You can't really add objects to the build before the patch that
>> adds the source for that object.
>>
> 
> Hi david,
> 
> Fixed patch attached.

ping ...


