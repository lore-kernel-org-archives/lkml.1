Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbYKLBoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbYKLBoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 20:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYKLBoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 20:44:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:41840 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbYKLBoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 20:44:08 -0500
Message-ID: <491A34DE.5030406@kernel.org>
Date: Wed, 12 Nov 2008 10:43:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Tim Connors <tconnors@rather.puzzling.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: sata error on ICH8M
References: <alpine.DEB.2.00.0811040833110.24370@dirac.rather.puzzling.org> <49199029.8070802@kernel.org> <4919976E.6020205@rtr.ca>
In-Reply-To: <4919976E.6020205@rtr.ca>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 12 Nov 2008 01:44:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
>> I really need to see how the recovery attempt failed.  Can you please
>> reproduce the problem and report the kernel log?  Also, please report
>> how reproducible the problem is.
> ...
> 
> 
> I wonder if this is another scenario, where a full reset of the AHCI host
> would recover the system, similar to the one I emailed you about last
> month.. ?

The one you emailed me last month didn't require host reset after all.
It just needed small adjustment to reset protocol and the upstream
kernel worked fine with it w/o any modification.

Thanks.

-- 
tejun
