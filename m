Return-Path: <linux-kernel-owner+w=401wt.eu-S1765718AbYCGUeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765718AbYCGUeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 15:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761588AbYCGUdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 15:33:55 -0500
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:52305 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761033AbYCGUdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:33:54 -0500
To: Frans Pop <elendil@planet.nl>
Subject: Re: extra bytes written to SATA DVD drive on kernel 2.6.23 till 2.6.24.2
Cc: efault@gmx.de, gml@inode.at, htejun@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       vsu@altlinux.ru
In-reply-To: <E1JXic1-0000Yo-K8@faramir.fjphome.nl>
References: <200802252005.22663.gml@inode.at> <200803011329.11315.gml@inode.at> <47D0FF67.8050503@gmail.com> <47D0FF67.8050503@gmail.com> <200803072009.22551.gml@inode.at> <200803072009.22551.gml@inode.at> <E1JXic1-0000Yo-K8@faramir.fjphome.nl>
Message-Id: <E1JXjFR-0000wV-Uf@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Fri, 07 Mar 2008 21:32:57 +0100
X-OriginalArrivalTime: 07 Mar 2008 20:32:58.0709 (UTC) FILETIME=[6E796850:01C88092]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Gerold Jury wrote:
>> 0001ffe0  e0 ff e1 ff e2 ff e3 ff  e4 ff e5 ff e6 ff e7 ff 
>> |................|
>> 0001fff0  e8 ff e9 ff ea ff eb ff  ec ff ed ff ee ff ef ff 
>> |................|
>> 00020000  2a 00 00 00 00 40 00 00  40 00 00 00 00 40 00 00 
>> |*....@..@....@..|
> 
> Looks broken here too.

Please ignore. I probably wasn't looking right.

Sorry for the noise.
