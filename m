Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbZAaFfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbZAaFfg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 00:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbZAaFf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 00:35:28 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:34898 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZAaFf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 00:35:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SaiKR2ud8Z70cMwt/h5op1twkAZmJaJ/5visp566WdMe7Uc5tRzBQlaeXVWrlL8aGd
         OlA4yxlaWv8ApKcZiwx6eOqiFVNfCxp84J/VmpRhee9lTBPraGcyZxJOyVBToijTzknp
         C87JXTrouhvAeGgcPFDnoqnxyjMrBDYK3cr2I=
Message-ID: <4983E313.4070902@gmail.com>
Date: Sat, 31 Jan 2009 14:35:15 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 3/3] xen: use direct ops on 64-bit
References: <4983AC8A.6050501@goop.org>
In-Reply-To: <4983AC8A.6050501@goop.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Enable the use of the direct vcpu-access operations on 64-bit.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Hmmm... these three patches conflict with the previous two patches.
I'll soon send out a new tree.  Can you please wait a bit and refresh
the patches?

Thanks.

-- 
tejun
