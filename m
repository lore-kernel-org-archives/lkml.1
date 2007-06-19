Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbXFSPcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbXFSPcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756390AbXFSPbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:31:51 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:39394 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756315AbXFSPbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:31:50 -0400
Message-ID: <4677F6E1.50108@dgreaves.com>
Date: Tue, 19 Jun 2007 16:31:45 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>,
       David Robinson <zxvdr.au@gmail.com>,
       LVM general discussion and development 
	<linux-lvm@redhat.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>,
       LinuxRaid <linux-raid@vger.kernel.org>
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com> <4676D97E.4000403@dgreaves.com> <4677A0C7.4000306@dgreaves.com> <200706191321.07278.rjw@sisk.pl>
In-Reply-To: <200706191321.07278.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>> This is on 2.6.22-rc5
> 
> Is the Tejun's patch
> 
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc5/patches/30-block-always-requeue-nonfs-requests-at-the-front.patch
> 
> applied on top of that?

2.6.22-rc5 includes it.

(but, when I was testing rc4, I did apply this patch)

David
