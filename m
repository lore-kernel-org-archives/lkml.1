Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbZBDTk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbZBDTk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbZBDTkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:40:17 -0500
Received: from rtr.ca ([76.10.145.34]:48774 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbZBDTkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:40:16 -0500
Message-ID: <4989EF1D.4000106@rtr.ca>
Date: Wed, 04 Feb 2009 14:40:13 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Krishna Kothapalli <krishna_sunitha@hotmail.com>
Cc: kaneshige.kenji@jp.fujitsu.com, ebiederm@xmission.com,
       linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org, achiang@hp.com,
       djwong@us.ibm.com, xyzzy@speakeasy.org, linux-kernel@vger.kernel.org
Subject: Re: Q: state of pci express hotplug
References: <m1fxj06js8.fsf@fess.ebiederm.org> <4986581F.7060704@jp.fujitsu.com>   <BAY111-W15F61DA9CA66E14686D5F688C50@phx.gbl>   <49879508.4090801@jp.fujitsu.com>   <BAY111-W3692AA5F9F7896AA447A1F88C20@phx.gbl> <BAY111-W9013DA1F63973F9E7F8DF88C30@phx.gbl> <49892CDE.9040305@jp.fujitsu.com> <BAY111-W205B70ED6B226F2F9D8E2088C30@phx.gbl>
In-Reply-To: <BAY111-W205B70ED6B226F2F9D8E2088C30@phx.gbl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krishna Kothapalli wrote:
..
>>  - and the device didn't show up under sysfs
>>  Am I correct?
> 
>    YES
..

Does it behave better with the pciehp_force=1 option?

   modprobe  pciehp pciehp_force=1

