Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbZKPNYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbZKPNYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 08:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbZKPNYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 08:24:54 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:4483 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbZKPNYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 08:24:53 -0500
Message-ID: <4B01529A.80900@chelsio.com>
Date: Mon, 16 Nov 2009 18:54:42 +0530
From: Rakesh Ranjan <rakesh@chelsio.com>
Organization: Chelsio Communications
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: michaelc@cs.wisc.edu, open-iscsi@googlegroups.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@suse.de, kxie@chelsio.com
Subject: Re: [RFC-PATCH] libiscsi dhcp handler
References: <4B014F95.8000906@chelsio.com> <20091116.051835.125328285.davem@davemloft.net>
In-Reply-To: <20091116.051835.125328285.davem@davemloft.net>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Nov 2009 13:26:58.0484 (UTC) FILETIME=[7917D740:01CA66C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Rakesh Ranjan <rakesh@chelsio.com>
> Date: Mon, 16 Nov 2009 18:41:49 +0530
> 
>> Herein attached patches to support dhcp based provisioning for iSCSI
>> offload capable cards. I have made dhcp code as generic as possible,
>> please go through the code. Based on the feedback I will submit final
>> version of these patches.
> 
> You can't really add objects to the build before the patch that
> adds the source for that object.
> 

my mistake, the makefile part of patch is irrelevant. Will send new
patch in few mins.

Regards
Rakesh Ranjan

